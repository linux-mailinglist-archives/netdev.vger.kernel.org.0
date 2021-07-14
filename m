Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56383C937F
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 00:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhGNWDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 18:03:36 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:37714
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhGNWDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 18:03:35 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 194E140616;
        Wed, 14 Jul 2021 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626300036;
        bh=ERoUc/vzyGCRXP8MOtYZ/pVSmZpxoxwUYE99SyGVTro=;
        h=From:To:Subject:MIME-Version:Content-Type:Date:Message-ID;
        b=tVnU79lBWU7ZF93LXSUwyakQQjPlWXSTH317+JZ5IHPmbp2cgO8u8QJr0Go/TPcy4
         ApgeQ6zG2KuY59eSi0cYqOPiiIS5IJmo792Tn9/8goK9T7Yu4ltH7ZZTuz0PdYrzie
         mOXPHfEy78TLUtV5ujgHLp6A06GfqBvrY6WuvVyHifTKpZz1sjh+q2LAv33gnuET/V
         L4FFcYzIajVAO/0J8S1Qfup7faWpXSRphPEBal0jsIYtVipjDx24jYgtfL97DfpWc4
         byXG9vxZCyz8xtKIciqr99mOFWFtpO3bCYGOdQeC20zxycyHB8YnzIEQMceVX4zNok
         nX6imWQwQdRgA==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 689095FBC1; Wed, 14 Jul 2021 15:00:34 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 61C40A040B;
        Wed, 14 Jul 2021 15:00:34 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Taehee Yoo <ap420073@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, vfalico@gmail.com, andy@greyhouse.net,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jarod@redhat.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net v2 0/9] net: fix bonding ipsec offload problems
In-reply-to: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Comments: In-reply-to Taehee Yoo <ap420073@gmail.com>
   message dated "Mon, 05 Jul 2021 15:38:05 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25260.1626300034.1@famine>
Date:   Wed, 14 Jul 2021 15:00:34 -0700
Message-ID: <25261.1626300034@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:

>This series fixes some problems related to bonding ipsec offload.
>
>The 1, 5, and 8th patches are to add a missing rcu_read_lock().
>The 2nd patch is to add null check code to bond_ipsec_add_sa.
>When bonding interface doesn't have an active real interface, the
>bond->curr_active_slave pointer is null.
>But bond_ipsec_add_sa() uses that pointer without null check.
>So that it results in null-ptr-deref.
>The 3 and 4th patches are to replace xs->xso.dev with xs->xso.real_dev.
>The 6th patch is to disallow to set ipsec offload if a real interface
>type is bonding.
>The 7th patch is to add struct bond_ipsec to manage SA.
>If bond mode is changed, or active real interface is changed, SA should
>be removed from old current active real interface then it should be added
>to new active real interface.
>But it can't, because it doesn't manage SA.
>The 9th patch is to fix incorrect return value of bond_ipsec_offload_ok().
>
>v1 -> v2:
> - Add 9th patch.
> - Do not print warning when there is no SA in bond_ipsec_add_sa_all().
> - Add comment for ipsec_lock.
>
>Taehee Yoo (9):
>  bonding: fix suspicious RCU usage in bond_ipsec_add_sa()
>  bonding: fix null dereference in bond_ipsec_add_sa()
>  net: netdevsim: use xso.real_dev instead of xso.dev in callback
>    functions of struct xfrmdev_ops
>  ixgbevf: use xso.real_dev instead of xso.dev in callback functions of
>    struct xfrmdev_ops
>  bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
>  bonding: disallow setting nested bonding + ipsec offload
>  bonding: Add struct bond_ipesc to manage SA
>  bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
>  bonding: fix incorrect return value of bond_ipsec_offload_ok()
>
> drivers/net/bonding/bond_main.c            | 181 +++++++++++++++++----
> drivers/net/ethernet/intel/ixgbevf/ipsec.c |  20 ++-
> drivers/net/netdevsim/ipsec.c              |   8 +-
> include/net/bonding.h                      |   9 +-
> 4 files changed, 178 insertions(+), 40 deletions(-)

	The bonding portion looks good to me.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
