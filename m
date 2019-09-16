Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0958BB3525
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfIPHKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:10:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45023 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfIPHKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:10:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id q21so22411685pfn.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=o3XIi9DXgd4LD2pExhDGPxp98Z+4PuuIDlbpCDFeAXg=;
        b=IzhTEFNUnJlKF1HvlvOJ5S366tDykv8A/QyBPs/QEukcysRbpA60IXTNLIoqjUDB37
         BV58Lg+AcJYa+SgM9ceFUWr/dGGw/Z1Cjy/UjghwvEaTT3JObJaEA3DLT9UYKhgs0UDd
         dn6BXqgdQE4nJwZd+G4vrApeZozlZINnvlqlEnN9oia8v+ANw57aqex1q70YpvmHR7/G
         7MaK7ni5rFvYhQNcRqPLBo8LswrR6+tosTd3kai8ajNM57Zg1GLNhOXkpKGy/NFctWxq
         tnFjB6ktiSI17BAOhEbrNJiR/J4tG73AtNr5HQi57QAw4qolDwNaRNhJf8YdPFiGV9+d
         C+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o3XIi9DXgd4LD2pExhDGPxp98Z+4PuuIDlbpCDFeAXg=;
        b=pA7kIxaV5zypJZ7PljOuXWeWqS40X3L5emxsesM2AEzf21fMcRGaYk+UkgsPS/REGO
         lDmaV/F3rok1+cAkFoyOX6qYvKms3qMH+blpS79xsDNlD6ybDHoJlByBFaYvV/17nMdw
         qtQbz99M6ThjR2bn8kMYtb/KOJn4Fo/x5/dTwGLipNn9i6FXL8txp+2iOW5o1wx2ALtH
         TbIcQcxDN+m/owAjIJxPdO4qeVJ5rsEWDDtcghpw9c3/V2Vx1+yavCkHqKFfsAkLtMgL
         vfajNMqIkUERqfMY8IKMLO5fKUq08ii5KEf2dgrVUnkIDkpJeEAMQDqfoIju5U5VhBiD
         Gcdg==
X-Gm-Message-State: APjAAAV+e5Q6OUsNGtdjHM611XA0rxUT+Pve5OFSFGD0HyKU2cJaNZDD
        5CG0OrkXcIzN70+X+9DsNya4rjzgiuQ=
X-Google-Smtp-Source: APXvYqxzZcYG5WULT5GvsxZcya+FQ5XKralAQhRU5gMBMDLey3GR4qqUH8eGXHYA1o2UK8ZRnB1cFA==
X-Received: by 2002:a65:4505:: with SMTP id n5mr49471500pgq.301.1568617828830;
        Mon, 16 Sep 2019 00:10:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a12sm12900486pfn.95.2019.09.16.00.10.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:10:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 0/6] net: add support for ip_tun_info options setting
Date:   Mon, 16 Sep 2019 15:10:14 +0800
Message-Id: <cover.1568617721.git.lucien.xin@gmail.com>
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

As an example I also wrote a patch for iproute2 that I will reply on this
mail, with it we can add options for erspan lwtunnel like:

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

