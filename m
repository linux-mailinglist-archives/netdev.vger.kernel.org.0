Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251E125C92C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgICTOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgICTOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 15:14:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B9FA208CA;
        Thu,  3 Sep 2020 19:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599160470;
        bh=fVAV7ORHpgAuQL8kldxZIJsiq8sgyq7yp5XvA5SqRb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GCLtyavT3HAMXjAV5TFlSh1Mmf7DsGfvz+77sEfODmZAj0ikGSQx1tB8SwNBmtHSO
         c8SlZJONjqq9TDs2m+bHqTrGyBz13+bzrDVSXylu+lhHcQGm3cvH50kWYpzUwU0XfA
         S4oEj6pCRaTdnp6hDTv5TmJJ81nKzw+ml8hjnSss=
Date:   Thu, 3 Sep 2020 12:14:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: Failing to attach bond(created with two interfaces from
 different NICs) to a bridge
Message-ID: <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:
> Hello Jiri,
> 
> After the following set of upstream commits, the user fails to attach
> a bond to the bridge, if the user creates the bond with two interfaces
> from different bnxt_en NICs. Previously bnxt_en driver does not
> advertise the switch_id for legacy mode as part of
> ndo_get_port_parent_id cb but with the following patches, switch_id is
> returned even in legacy mode which is causing the failure.
> 
> ---------------
> 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
> devlink_compat_switch_id_get() helper
> 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
> devlink_port_attrs_set()
> 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
> ndo_get_port_parent_id implementation for physical ports
> ----------------
> 
> As there is a plan to get rid of ndo_get_port_parent_id in future, I
> think there is a need to fix devlink_compat_switch_id_get() to return
> the switch_id only when device is in SWITCHDEV mode and this effects
> all the NICs.
> 
> Please let me know your thoughts. Thank you.

I'm not Jiri, but I'd think that hiding switch_id from devices should
not be the solution here. Especially that no NICs offload bridging
today. 

Could you describe the team/bridge failure in detail, I'm not that
familiar with this code.
