Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE87CFD60
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfJHPQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:16:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34663 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJHPQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:16:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id y35so10440619pgl.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3QVmGeBwVHAwUwSjvZwiB+ZqcwrEgGjX0sFzJZaTaOc=;
        b=eTYC5ZIqVbb+welKGURZnwH+RQfsOY2WOFR4R+3k6JUl3iqHlAD/+DdIEqwMX+eVBP
         hDJPedK4DwEd3p0qnq86SJKaOo12DvjIrGbp9koWCGAEeUtSckovb4Ogf7iKu34wKC6+
         Ja77RuKawg4GjsK1Fwbt7yAloXQXDPwjH82Eed91ue0M8bsWM1o5dmztB/cVW/jMx1O0
         Ztsn3mBVVdzzMbIS/1vMhewklpEO++Y32uPC0wd6cJ6WOjtxCkBzYER4THEzP4OZojk8
         5xNVPQhq0DzxJ5uzENbcCpzacG3ZxFLKHttAgXaMvz1mR4zZ9QK18JLlbBHkDRXzTvWt
         I/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3QVmGeBwVHAwUwSjvZwiB+ZqcwrEgGjX0sFzJZaTaOc=;
        b=KibBLA2JRn4JTUsmqhrlxTJRJsDS76bwYwcJg30Wdcl9xkN4Y78ZRO8qxb09cZ/hwI
         xPHmgSeMPYpTOWHGXbIFoZD9eMvZv31YC5jvDvJgAKdXnyus+Lw55OFbzrMbDwBMecz5
         8sAXRDeNttg+A64h7Y25+mVB+J4u6u5GNuCORaS6u0J4VU54bKCErQAbsfbRERwCoFF8
         ujSWUq/ijOvTK2fnQrn7nz0OmCIAQH44hNzLVUA4IX+3GPWAPovade3jEXXOG8VoG7xQ
         KDBYFEkE66EZTwFUAuk4QkSFZibvbEqWqSunVy5IvXFtWSxlxxnggBGDe9x7Mwtt/DxY
         nRoQ==
X-Gm-Message-State: APjAAAXGGLpH/mXwME5SjGvm4+7VTU2dizJY+xh9FxIRbvuY0U6AT6gd
        EZ+V1c/q4SM0OOyeqyfxM+1xjKa2
X-Google-Smtp-Source: APXvYqz8HnXU/eQlFbwbJCkEsWxPyLqS3B4Fc3ol+cmws49G3XTY7SDauquPmj5NtRnEcAxfnRwSEQ==
X-Received: by 2002:aa7:9e50:: with SMTP id z16mr40348041pfq.83.1570547784377;
        Tue, 08 Oct 2019 08:16:24 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q13sm2427777pjq.0.2019.10.08.08.16.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 0/6] net: add support for ip_tun_info options setting
Date:   Tue,  8 Oct 2019 23:16:10 +0800
Message-Id: <cover.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patchset, users can configure options with LWTUNNEL_IP(6)_OPTS
by ip route encap for ersapn or vxlan lwtunnel. Note that in kernel part
it won't parse the option details but do some check and memcpy only, and
the options will be parsed by iproute in userspace.

We also improve the vxlan and erspan options processing in this patchset.

As an example I also wrote a patch for iproute2 (see v1), with it we can
add options for erspan lwtunnel like:

   # ip net a a; ip net a b
   # ip -n a l a eth0 type veth peer name eth0 netns b
   # ip -n a l s eth0 up; ip -n b link set eth0 up
   # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
   # ip -n b l a erspan1 type erspan key 1 seq erspan 123 \
        local 10.1.0.2 remote 10.1.0.1
   # ip -n b a a 1.1.1.1/24 dev erspan1; ip -n b l s erspan1 up
   # ip -n b r a 2.1.1.0/24 dev erspan1
   # ip -n a l a erspan1 type erspan key 1 seq local 10.1.0.1 external
   # ip -n a a a 2.1.1.1/24 dev erspan1; ip -n a l s erspan1 up
   # ip -n a r a 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
        dst 10.1.0.2 dev erspan1
   # ip -n a r s; ip net exec a ping 1.1.1.1 -c 1

v1->v2:
  - no change, net-next reopened.

Xin Long (6):
  lwtunnel: add options process for arp request
  lwtunnel: add LWTUNNEL_IP_OPTS support for lwtunnel_ip
  lwtunnel: add LWTUNNEL_IP6_OPTS support for lwtunnel_ip6
  vxlan: check tun_info options_len properly
  erspan: fix the tun_info options_len check
  erspan: make md work without TUNNEL_ERSPAN_OPT set

 drivers/net/vxlan.c           |  6 +++--
 include/uapi/linux/lwtunnel.h |  2 ++
 net/ipv4/ip_gre.c             | 31 ++++++++++-------------
 net/ipv4/ip_tunnel_core.c     | 59 +++++++++++++++++++++++++++++++++----------
 net/ipv6/ip6_gre.c            | 35 +++++++++++++------------
 5 files changed, 84 insertions(+), 49 deletions(-)

-- 
2.1.0

