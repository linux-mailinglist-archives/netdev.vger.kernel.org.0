Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55F442D5F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406443AbfFLRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:24:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35837 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbfFLRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:24:10 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so13633670ioo.2
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=dR4ULyP2ZUmYk12NNS+F8xi8tml4Imeh7ETZvZ7ywsY=;
        b=ZvGoRmTGCUBFcipozkDESxQ7D5Ejyhh1XacNxM8IXvOMkXzdAx/MSKZQQG0O0d+tTv
         9t/f4fHMwkkCPcfn4ypKvI7PMr89fwU7NVUkBDGq8INo96L2OpiBo/z2ToWzGzSdHRnu
         VN+Csz1ImuLIlZOHc7oBGsQRsDEcJJKHPkkLa8zRDLjpK7JAEIl7dqQ7gxdomkTrJCks
         /xvgY90KBVdb2iSd4xdP+7Kbjp/X58d15dYTfHsQmZ/pnjQEf8bC0SAk/DLMduVhihNd
         raf0tKc0mtQcXah3UlcdPX+SSheg8GQx1s6NkcJnunukHck7+kVrbnBjeCQFVtLi4O2d
         Bhvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=dR4ULyP2ZUmYk12NNS+F8xi8tml4Imeh7ETZvZ7ywsY=;
        b=BUeTIkyjwFwNixVpUoDRYLbjxtRlH93DX3KeJ/Mc7RgZkMXYnS+/X4iqHpIyCLe+EC
         iNtSzd8Fiie6a4LUF1kN7XldE8aAlQma3esArLifPdsIgwUb2zfODg+bwFBEAsxP2i7s
         tLomoTImAU3nX+c62OD6o2tUZZqtUzAYdKgmn+IYbfligAXlQcJS90duAapKcuGc4owU
         v3ZInBuOvDjlXCk4zdcdcAte8HCG2Pjew2WCNVXJR6YStpEDNz5PV/lckg47KMfcm/CS
         2Yd5u8TKUXMpdoZyqyneXo3hmIupASEvKv86OOSNa62iiobF1JkGetBtPJlOwKx/ftp1
         wfig==
X-Gm-Message-State: APjAAAWhmKIuPCvXKabfKh+UYEJOC0QxSmNpC4hfGqglSFRFGZF2TU4d
        6Cz36fobzMQTpghdjlUPZso=
X-Google-Smtp-Source: APXvYqx84uBUFYMZlm0Oe9ZeaNACvU3zpbqEZJ7Sh0cH0uVlxRr4tOK43C7sJQ3WeMgUoanN2YoWFQ==
X-Received: by 2002:a5e:8210:: with SMTP id l16mr3671142iom.240.1560360250035;
        Wed, 12 Jun 2019 10:24:10 -0700 (PDT)
Received: from [192.168.122.156] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a130sm204543itb.14.2019.06.12.10.24.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 10:24:09 -0700 (PDT)
Subject: [net PATCH v2] net: tls,
 correctly account for copied bytes with multiple sk_msgs
From:   John Fastabend <john.fastabend@gmail.com>
To:     steinar+kernel@gunderson.no, daniel@iogearbox.net, andre@tomt.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        davem@davemloft.net
Date:   Wed, 12 Jun 2019 17:23:57 +0000
Message-ID: <156036023770.7273.14464005268434910852.stgit@ubuntu-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_sw_do_sendpage needs to return the total number of bytes sent
regardless of how many sk_msgs are allocated. Unfortunately, copied
(the value we return up the stack) is zero'd before each new sk_msg
is allocated so we only return the copied size of the last sk_msg used.

The caller (splice, etc.) of sendpage will then believe only part
of its data was sent and send the missing chunks again. However,
because the data actually was sent the receiver will get multiple
copies of the same data.

To reproduce this do multiple sendfile calls with a length close to
the max record size. This will in turn call splice/sendpage, sendpage
may use multiple sk_msg in this case and then returns the incorrect
number of bytes. This will cause splice to resend creating duplicate
data on the receiver. Andre created a C program that can easily
generate this case so we will push a similar selftest for this to
bpf-next shortly.

The fix is to _not_ zero the copied field so that the total sent
bytes is returned.

Reported-by: Steinar H. Gunderson <steinar+kernel@gunderson.no>
Reported-by: Andre Tomt <andre@tomt.net>
Tested-by: Andre Tomt <andre@tomt.net>
Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 960494f437ac..455a782c7658 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1143,7 +1143,6 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 
 		full_record = false;
 		record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
-		copied = 0;
 		copy = size;
 		if (copy >= record_room) {
 			copy = record_room;

