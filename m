Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4950860D992
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiJZDIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiJZDIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A81E01C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 20:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FEA561B7C
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 03:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8731C433C1;
        Wed, 26 Oct 2022 03:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753692;
        bh=nKclqLDj6kmwfoQRx82ZS/OgaoYiSYjC1FZc1wZb++w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QEjn6F6DtJpBF7pRPOHdI3J8hpuGjmLtAB7oEvK/nsFuWVKt83Ik9joDya9/gpb5T
         TLQMWkkTOcsleZP4itoicQFQwjNiRjqBeBWarUcxcZZ2IpyeUW25L7U4Ge0Im6j1m2
         K0WedYXJFadOu4SFdzj15GjcxCrmVnNbQO09X6pUzz0A2PiSN8u3p0o/7oj4+y0u2c
         yNW2LHDMxcRs1wNXR459xuZvxIH9PPwVis8FhFmZps5n1ajF4DlxjAgfBZ8U/k+tWO
         gsIFK9FgunvKh4P3ZLFQdDARZi65c/qF9CmhkM168PKbLqhIPRifc9k1zrIU0HO/yL
         twRa9pkzO5HfQ==
Date:   Tue, 25 Oct 2022 20:08:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, leon@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH v2 net-next 3/5] ionic: new ionic device identity level
 and VF start control
Message-ID: <20221025200811.553f5ab4@kernel.org>
In-Reply-To: <20221025112426.8954-4-snelson@pensando.io>
References: <20221025112426.8954-1-snelson@pensando.io>
        <20221025112426.8954-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 04:24:24 -0700 Shannon Nelson wrote:
> A new ionic dev_cmd is added to the interface in ionic_if.h,
> with a new capabilities field in the ionic device identity to
> signal its availability in the FW.  The identity level code is
> incremented to '2' to show support for this new capabilities
> bitfield.
> 
> If the driver has indicated with the new identity level that
> it has the VF_CTRL command, newer FW will wait for the start
> command before starting the VFs after a FW update or crash
> recovery.
> 
> This patch updates the driver to make use of the new VF start
> control in fw_up path to be sure that the PF has set the user
> attributes on the VF before the FW allows the VFs to restart.

You need to tidy up the kdoc usage..

> @@ -54,6 +54,7 @@ enum ionic_cmd_opcode {
>  	/* SR/IOV commands */
>  	IONIC_CMD_VF_GETATTR			= 60,
>  	IONIC_CMD_VF_SETATTR			= 61,
> +	IONIC_CMD_VF_CTRL			= 62,

not documented

>  
>  	/* QoS commands */
>  	IONIC_CMD_QOS_CLASS_IDENTIFY		= 240,

> +/**
> + * struct ionic_vf_ctrl_cmd - VF control command
> + * @opcode:         Opcode for the command
> + * @vf_index:       VF Index. It is unused if op START_ALL is used.
> + * @ctrl_opcode:    VF control operation type
> + */
> +struct ionic_vf_ctrl_cmd {
> +	u8	opcode;
> +	u8	ctrl_opcode;
> +	__le16	vf_index;
> +	u8	rsvd1[60];

not documented

> +};
> +
> +/**
> + * struct ionic_vf_ctrl_comp - VF_CTRL command completion.
> + * @status:     Status of the command (enum ionic_status_code)
> + */
> +struct ionic_vf_ctrl_comp {
> +	u8	status;
> +	u8      rsvd[15];
> +};

not documented

For the rsvd fields you can use the /* private: */ comment,
see the docs.
