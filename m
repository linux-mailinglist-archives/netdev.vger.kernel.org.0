Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BFDECC26
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfKBAMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:12:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31119 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbfKBAMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572653533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3a8267M+RHJNRr07VE5ml30G5v7tWW7jIUnKYNL4CMo=;
        b=b/FYAK+Mi1DKZf442aWI7+HNmNEe3l9bjR3KeU35IMp31YQC8oJ+z/mrEDmsnZI7kxIYQD
        2Q2GuKRqrVC7gFD9C0KMGwhG2GgcmOfUycjlzYYtlJPsIGAfiz4n9W8NOLH/glPRR5caVu
        5gSbflphZtVNtrqUz36Fx2dTtJBKccc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-p5FJEoOSOY2Xqqg2a01XUw-1; Fri, 01 Nov 2019 20:12:11 -0400
Received: by mail-wr1-f71.google.com with SMTP id f4so6495432wrj.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 17:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VX6BMhZnxFI/3YJV1VoE+a6y4VVLv+nOV4fd/3YTNIk=;
        b=XCP/1jZv+ixCjr/zPd2w8N1XbOvJM2nnc++vVuswW6aYq23t8uXJrZGbuO66yiDfdA
         eRWh0tW/VqChvuA8jigVhK179ZdHdWWPGAH1uc1cXTvTOuFYBmAw+rrdA9NAL54Pb8wr
         qqya91fCtwcJFRlZhy1+R+Mr1JV+tmL3JBuV6mon1OnFH0mYY8Hcd8izKIouEoKnAV+d
         pdF7EeHQ3LLf1yJLvmlJ85781ZMGIGeWhxQazd0AShasihoJj0klE7t7HpdmQQCGOs2j
         1u5bjvReus/sN5TEeFXxwCkbatLePrfUlwVMbopB1p09W0nomi1WYSOBzxJYG9U9BMIK
         0IVQ==
X-Gm-Message-State: APjAAAWIdGDWLb8YPQvzijJV+BYni1hCj+6yjwCF4rwOfCRhPM+7+XHZ
        lZYqAcuXWx8ev6eDPXQEUA+HTpxFb/PWKxEIAVKspgujYO4j/s71KuBcFZ6oNfHA5a79YvSungk
        rcW76GqD3QjgC/Mum
X-Received: by 2002:a1c:9ccd:: with SMTP id f196mr12489848wme.152.1572653530238;
        Fri, 01 Nov 2019 17:12:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw4oLNGypYFr8/Qg3GXixLBynH2wHCRqp7hWXE77wgSMGttnht7B+mbeCcRpbJfTfqxa6l+UQ==
X-Received: by 2002:a1c:9ccd:: with SMTP id f196mr12489834wme.152.1572653530002;
        Fri, 01 Nov 2019 17:12:10 -0700 (PDT)
Received: from raver.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id a16sm13654781wmd.11.2019.11.01.17.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:12:09 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] icmp: move duplicate code in helper functions
Date:   Sat,  2 Nov 2019 01:12:02 +0100
Message-Id: <20191102001204.83883-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: p5FJEoOSOY2Xqqg2a01XUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some duplicate code by moving it in two helper functions.
First patch adds the helpers, the second one uses it.

Matteo Croce (2):
  icmp: add helpers to recognize ICMP error packets
  icmp: remove duplicate code

 include/linux/icmp.h                    | 15 +++++++++++++++
 include/linux/icmpv6.h                  | 14 ++++++++++++++
 net/ipv4/netfilter/nf_socket_ipv4.c     | 10 +---------
 net/ipv4/route.c                        |  5 +----
 net/ipv6/route.c                        |  5 +----
 net/netfilter/nf_conntrack_proto_icmp.c |  6 +-----
 net/netfilter/xt_HMARK.c                |  6 +-----
 net/sched/act_nat.c                     |  4 +---
 8 files changed, 35 insertions(+), 30 deletions(-)

--=20
2.23.0

