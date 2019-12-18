Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8045C1246F7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfLRMhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:37:21 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:55007 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfLRMhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:37:21 -0500
Received: by mail-pj1-f52.google.com with SMTP id ep17so817528pjb.4;
        Wed, 18 Dec 2019 04:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=SDfBkN3VJf5jvQD3fKgAU+xo/Y2l5f5r8EL8+ID85KA=;
        b=gMiz6Nraeacz1pgHx0sxX6cGe+A7DVbn1+tUGN1ReWgzlEZQVWWz1fPBXsaQdg6WX5
         AI4NGJA4oIJEhh8sXOlWxXjpJeQiacSdCVMsTvw7k79WrNrfZdyvF01ekd/99pIuNSk7
         l6DFFgcQCfjaGV7ovXfpdi4oOaLE6fGAwLXmAtAecubjMYQ2LGma8xFNtzcIVQHxymR0
         AZbswJYHVYVsGIcV8bNKpboO0lYKI/jZ7xguig4cSQTVtnJoSmKj2JCBK4wUmVTTmPsm
         SBrwtimlBVItCSWQDudgNrEGMagz41l1pFQehSZjTbXZA/IXsi0vtdMZIRdcbku3ivJl
         gRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=SDfBkN3VJf5jvQD3fKgAU+xo/Y2l5f5r8EL8+ID85KA=;
        b=H1HNSn1ffMAHGfu0S7MYoAtfUK0wTLR5xZOlYYZVeL+XAhOMiAdi7rCC5wAiplx6LH
         Ohpz/Zp+AG7cfFeD3Zm2t/oskFEiRZ8zcdW7DSkAVjHY+94An3+kaAUY1Gg4F3f3auuN
         hmFgAfXItNHIbpWug+MaxeCCsHe2Xu7ocdyxUTRbSNH6U/CS7f+4Fv/81eZgMWi+o/0W
         gdINfDBVD2+vrWT2AwH8O6sLpRpt2zLLneNNI0BgqtGEWkHriCzoKFQawmF2qYxTkejF
         i5lVlqJXdlEE9WiaruGEtWUGFzMUAiRL7E4pUPv2dCGizXiRQqBLlSbdQ9w/lM5f4wiU
         YXQA==
X-Gm-Message-State: APjAAAWZWYuB7TwVfafyhuSGd0GDFqzqWeZIt0Qe1mQm0NnoIq9z7K0X
        qkVByfwGbultYI0fjXbSmgSaWHmsrRr57g==
X-Google-Smtp-Source: APXvYqwKHlr/DWW77+DCtxg0yDJBmtZIIAMafU7Trkih5YEuKsYAAz8HhqBoS+Zjq3bON0Kb2FCR5w==
X-Received: by 2002:a17:902:a70c:: with SMTP id w12mr2529732plq.124.1576672640391;
        Wed, 18 Dec 2019 04:37:20 -0800 (PST)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.139.103? ([2402:f000:1:1501:200:5efe:a66f:8b67])
        by smtp.gmail.com with ESMTPSA id x4sm3236162pfx.68.2019.12.18.04.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 04:37:19 -0800 (PST)
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: bluetooth: a possible sleep-in-atomic-context bug in
 disconnect_all_peers()
Message-ID: <b1e7cccf-6e5e-aae8-09fc-6caafedc4a65@gmail.com>
Date:   Wed, 18 Dec 2019 20:37:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel module may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

net/bluetooth/l2cap_core.c, 840:
     mutex_lock in l2cap_get_ident
net/bluetooth/l2cap_core.c, 1402:
     l2cap_get_ident in l2cap_send_disconn_req
net/bluetooth/l2cap_core.c, 736:
     l2cap_send_disconn_req in l2cap_chan_close
net/bluetooth/6lowpan.c, 1053:
     l2cap_chan_close in disconnect_all_peers
net/bluetooth/6lowpan.c, 1051:
     spin_lock in disconnect_all_peers

mutex_lock() can sleep at runtime.

I am not sure how to properly fix this possible bug, so I only report it.

This bug is found by a static analysis tool STCheck written by myself.


Best wishes,
Jia-Ju Bai
