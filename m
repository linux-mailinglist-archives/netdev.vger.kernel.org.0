Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19674B8D28
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbiBPQB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:01:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiBPQB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:01:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894CE201A5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E9CFB81F64
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C33CC004E1;
        Wed, 16 Feb 2022 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645027302;
        bh=4SskxWaCMLBmf/GOdXrvlzSMrPiGEQKp3YUJfH09FW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gG6ypGQdp2v2JNm6bG9guGLmLSdoFVS6qe1XhwyVhh+yZAYZeQPbwzX/b3GfiBEx/
         JC73w4gdusruNSNrjAViBhvH17+9OKWLVBts7YjZZYgLZiuGn7XGo7KPRMWnlQJoiA
         H/Y7HESCtb8Q3RaAFGDBRhUIyaKs5pld04lJoNTjY3XgMNbhisl7a4ImGVPLZBMwkQ
         Vllp7wUfvR3Pmi83xZG4dfIcbEFypZ2sVt+kXP0A9ta/lSRM7QraYo9mngITMgwzzT
         8T1IH27W8JkQPGncW6Jw7aqO1otbFICxDuJEEhzssm81Wtsr2k1kL0iC9paRo7mCjh
         NjuFL1Be5i+wQ==
Date:   Wed, 16 Feb 2022 08:01:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 00/11] Replay and offload host VLAN entries
 in DSA
Message-ID: <20220216080140.2b16ee78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 19:02:07 +0200 Vladimir Oltean wrote:
> v2->v3:
> - make the bridge stop notifying switchdev for !BRENTRY VLANs
> - create precommit and commit wrappers around __vlan_add_flags().
> - special-case the BRENTRY transition from false to true, instead of
>   treating it as a change of flags and letting drivers figure out that
>   it really isn't.
> - avoid setting *changed unless we know that functions will not error
>   out later.
> - drop "old_flags" from struct switchdev_obj_port_vlan, nobody needs it
>   now, in v2 only DSA needed it to filter out BRENTRY transitions, that
>   is now solved cleaner.
> - no BRIDGE_VLAN_INFO_BRENTRY flag checks and manipulations in DSA
>   whatsoever, use the "bool changed" bit as-is after changing what it
>   means.
> - merge dsa_slave_host_vlan_{add,del}() with
>   dsa_slave_foreign_vlan_{add,del}(), since now they do the same thing,
>   because the host_vlan functions no longer need to mangle the vlan
>   BRENTRY flags and bool changed.

Appears applied, commit f0ead99e623b ("Merge branch
'Replay-and-offload-host-VLAN-entries-in-DSA'") in net-next, thanks!
