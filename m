Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4362676353
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjAUDVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUDVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:21:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717386E0DE;
        Fri, 20 Jan 2023 19:21:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24075B82B8A;
        Sat, 21 Jan 2023 03:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ED8C433D2;
        Sat, 21 Jan 2023 03:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674271261;
        bh=u03+9YLGMyAzqxcb5WaZli1ywOy/8WEW6RNhJoamwIo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vR4XX4lUj0i+3xjnU1BnPKvauCzYT21UFbkmulmoN9Xgq6ejTNw4ngaONIdMErLoa
         i9C4R1RWMe2cSIjHTY1Zq4OtKBeG+PkJKC9EIUZFnpHsLPrrV5WoreK3FB6206v9/z
         uL/XWRNpynCvvxTgXf0q+xsgx+Z58t44S59N0A2uVEY1wLW3tGIqsR1WmpXBjmMRIf
         /hO5eetXGlwhAOd9Pv51ZSH2BRva+8cD2LVwhXrBOMIwiRkUuTkW42qtzawX3G0Wbe
         6tga7Kcv8FiEmrFhpMV2a0RAEkCatwYYiL2NVXfdISQ4IwCuaA6ls9D4hQfwFDiFDl
         +UqR+c3mQ6lOQ==
Date:   Fri, 20 Jan 2023 19:20:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 5/7] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <20230120192059.66d058bf@kernel.org>
In-Reply-To: <31e46f564a30e0d3d1e06edb27045be9f318ff0b.1674234430.git.lorenzo@kernel.org>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <31e46f564a30e0d3d1e06edb27045be9f318ff0b.1674234430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 18:16:54 +0100 Lorenzo Bianconi wrote:
> +static int libbpf_netlink_resolve_genl_family_id(const char *name,
> +						 __u16 len, __u16 *id)
> +{
> +	struct libbpf_nla_req req = {
> +		.nh.nlmsg_len	= NLMSG_LENGTH(GENL_HDRLEN),
> +		.nh.nlmsg_type	= GENL_ID_CTRL,
> +		.nh.nlmsg_flags	= NLM_F_REQUEST,
> +		.gnl.cmd	= CTRL_CMD_GETFAMILY,
> +		.gnl.version	= 1,

nlctrl is version 2, shouldn't matter in practice
