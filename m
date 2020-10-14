Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3C628E101
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgJNNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:06:40 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55749 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgJNNGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:06:40 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 09:06:39 EDT
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d33dd42d;
        Wed, 14 Oct 2020 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:cc:content-type; s=mail; bh=vWG
        GXZkT/U/2yDjyBjpJdYwoFag=; b=x8yqxU77XFip1KssIa1XfNrvJ+H/N2cPvN4
        qTP/EUWhs+Uy4VYn4GpNXYeMTeO5xMzP97Q9PsOqWkuMiKRK/9JUdHlC+xO9qaOq
        Ks1OmkXhXZy4CYWytuOvrsWgF7APmHb2/1xz6LFOaf7JH0ERCg8qxXIvyq9vLeFz
        JCSJc4sVLr6KsTPdg9T7kauivC6k0QU+Ii6gKTRqN+I771I22HiITIBcuHYMOsML
        D4Es1S04Q8kERJtPbgdpnuCzQwN4Cd8Un+q7xB2V3mX8LoY0wZ2sqh7KokPHwpks
        7XcWDosL7zGio4baRtF8ycv8P4CPtqN6pwV11Rb3yhxq1EPlSDg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d40e42f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Oct 2020 12:26:26 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id r10so4901661ilm.11;
        Wed, 14 Oct 2020 05:59:58 -0700 (PDT)
X-Gm-Message-State: AOAM531Fcxpwi5CDRDqznrrL+s44xeZKvmPPat4KB8G+nhKm3doK21vA
        2YtuiPVZmE19jlTVHaNgS7NfTIRjfFAlWp5hz4o=
X-Google-Smtp-Source: ABdhPJwgn1aqj1woQi5SYMqFo7x06yJlwX2nYDR4yYzTw1pA6fcKktYbkvHlM6Ww2+CICTb5E/FLKsvcWpfGXjuEW9s=
X-Received: by 2002:a92:849a:: with SMTP id y26mr3840662ilk.38.1602680397881;
 Wed, 14 Oct 2020 05:59:57 -0700 (PDT)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 14 Oct 2020 14:59:47 +0200
X-Gmail-Original-Message-ID: <CAHmME9q_ExkdWXg6TMRnhwp7KGRQExooiP-jdpXiPqc=s1p4SA@mail.gmail.com>
Message-ID: <CAHmME9q_ExkdWXg6TMRnhwp7KGRQExooiP-jdpXiPqc=s1p4SA@mail.gmail.com>
Subject: iptables userspace API broken due to added value in nf_inet_hooks
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Pablo,

In 60a3815da702fd9e4759945f26cce5c47d3967ad, you added another enum
value to nf_inet_hooks:

--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -45,6 +45,7 @@ enum nf_inet_hooks {
       NF_INET_FORWARD,
       NF_INET_LOCAL_OUT,
       NF_INET_POST_ROUTING,
+       NF_INET_INGRESS,
       NF_INET_NUMHOOKS
};

That seems fine, but actually it changes the value of
NF_INET_NUMHOOKS, which is used in struct ipt_getinfo:

/* The argument to IPT_SO_GET_INFO */
struct ipt_getinfo {
       /* Which table: caller fills this in. */
       char name[XT_TABLE_MAXNAMELEN];

       /* Kernel fills these in. */
       /* Which hook entry points are valid: bitmask */
       unsigned int valid_hooks;

       /* Hook entry points: one per netfilter hook. */
       unsigned int hook_entry[NF_INET_NUMHOOKS];

       /* Underflow points. */
       unsigned int underflow[NF_INET_NUMHOOKS];

       /* Number of entries */
       unsigned int num_entries;

       /* Size of entries. */
       unsigned int size;
};

This in turn makes that struct bigger, which means this check in
net/ipv4/netfilter/ip_tables.c fails:

static int get_info(struct net *net, void __user *user, const int *len)
{
       char name[XT_TABLE_MAXNAMELEN];
       struct xt_table *t;
       int ret;

       if (*len != sizeof(struct ipt_getinfo))
               return -EINVAL;

This is affecting my CI, which attempts to use an older iptables with
net-next and fails with:

iptables v1.8.4 (legacy): can't initialize iptables table `filter':
Module is wrong version
Perhaps iptables or your kernel needs to be upgraded.

Is this kind of breakage okay? If there's an exception carved out for
breaking the iptables API, just let me know, and I'll look into making
adjustments to work around it in my CI. On the other hand, if this
breakage was unintentional, now you know.

Jason
