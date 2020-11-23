Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917732C0142
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgKWITj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:19:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgKWITi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606119577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdi2HhZ/hkHyKkGfU0FRMXdvsA6kz1Ug/WommlEtEbI=;
        b=GlVKhnW53oAxmnwGEdK+H2SKF8Lzwguisu/n8010a4Ig9cFJzCQRZEJhR/SLlQga3SUzMD
        AAIBgcWDPskEmyFHxSMtVcH0x256QKuxaD/k8u6ix8qPg08gndq5tEzQ6BTouxMzwaEC08
        4zEczn4dQWD2HAKgId3GAjsNaAYyiIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-0OVgoA-NPPKBxjBe6aAQmQ-1; Mon, 23 Nov 2020 03:19:32 -0500
X-MC-Unique: 0OVgoA-NPPKBxjBe6aAQmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD2C787950F;
        Mon, 23 Nov 2020 08:19:27 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C107620DE;
        Mon, 23 Nov 2020 08:19:22 +0000 (UTC)
Date:   Mon, 23 Nov 2020 09:19:21 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: fix feature flag setting at init time
Message-ID: <20201123091921.0277d562@ceranb>
In-Reply-To: <20201123031716.6179-1-jarod@redhat.com>
References: <20201123031716.6179-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 22:17:16 -0500
Jarod Wilson <jarod@redhat.com> wrote:

> Have run into a case where bond_option_mode_set() gets called before
> hw_features has been filled in, and very bad things happen when
> netdev_change_features() then gets called, because the empty hw_features
> wipes out almost all features. Further reading of netdev feature flag
> documentation suggests drivers aren't supposed to touch wanted_features,
> so this changes bond_option_mode_set() to use netdev_increment_features()
> and &= ~BOND_XFRM_FEATURES on mode changes and then only calling
> netdev_features_change() if there was actually a change of features. This
> specifically fixes bonding on top of mlxsw interfaces, and has been
> regression-tested with ixgbe interfaces. This change also simplifies the
> xfrm-specific code in bond_setup() a little bit as well.

Hi Jarod,

the reason is not correct... The problem is not with empty ->hw_features but
with empty ->wanted_features.
During bond device creation bond_newlink() is called. It calls bond_changelink()
first and afterwards register_netdevice(). The problem is that ->wanted_features
are initialized in register_netdevice() so during bond_changlink() call
->wanted_features is 0. So...

bond_newlink()
-> bond_changelink()
   -> __bond_opt_set()
      -> bond_option_mode_set()
         -> netdev_change_features()
            -> __netdev_update_features()
               features = netdev_get_wanted_features()
                          { dev->features & ~dev->hw_features) | dev->wanted_features }

dev->wanted_features is here zero so the rest of the expression clears a bunch of
bits from dev->features...

In case of mlxsw it is important that NETIF_F_HW_VLAN_CTAG_FILTER bit is cleared in
bonding device because in this case vlan_add_rx_filter_info() does not call
bond_vlan_rx_add_vid() so mlxsw_sp_port_add_vid() is not called as well.

Later this causes a WARN in mlxsw_sp_inetaddr_port_vlan_event() because
instance of mlxsw_sp_port_vlan does not exist as mlxsw_sp_port_add_vid() was not
called.

Btw. it should be enough to call existing snippet in bond_option_mode_set() only
when device is already registered?

E.g.:
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..ca4913fee5a9 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -768,11 +768,13 @@ static int bond_option_mode_set(struct bonding *bond,
                bond->params.tlb_dynamic_lb = 1;
 
 #ifdef CONFIG_XFRM_OFFLOAD
-       if (newval->value == BOND_MODE_ACTIVEBACKUP)
-               bond->dev->wanted_features |= BOND_XFRM_FEATURES;
-       else
-               bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-       netdev_change_features(bond->dev);
+       if (dev->reg_state == NETREG_REGISTERED) {
+               if (newval->value == BOND_MODE_ACTIVEBACKUP)
+                       bond->dev->wanted_features |= BOND_XFRM_FEATURES;
+               else
+                       bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
+               netdev_change_features(bond->dev);
+       }
 #endif /* CONFIG_XFRM_OFFLOAD */


Thanks,
Ivan

