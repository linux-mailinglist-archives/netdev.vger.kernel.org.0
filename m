Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506EF621F67
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKHWjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiKHWjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64326035E
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55F16617C9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 22:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71522C433D6;
        Tue,  8 Nov 2022 22:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667947177;
        bh=rU8reGtcXWbySBocNZXQI/uocrPsKFXxnlxtt5+WGVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScIcs6ID2i3dx/keHT4BSNIEn5wW9MGnUv2pbmilESXYDGF2l37ph5nTASWghWprm
         X5KBP+HtH75Mc4W/4av7MMqLVlKwQjhTsR5/FPOB2EoNZ9qqWRRM3tUEWwAN/qcW3g
         3s2djE94wAIpCuUOJGXN/YeSxMB/d4un9pWzM+smkVZmR+uhRKDtkfJY+lgpsli3XG
         Ac/AwmQp1xHUdWjiQqnBqMuxEnpiHr50iiyFEa9zcz8Ei31Q4GzN7xAR5paXeiCXUp
         xCbVTYxPRydT7MysKvIz124bNS+bRZMg5uZGApGKt5qRgCqhIXXJcg8lr7xNQEdshR
         e6ImBL++Kgasg==
Date:   Tue, 8 Nov 2022 14:39:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Message-ID: <20221108143936.4e59f6e8@kernel.org>
In-Reply-To: <20221107181327.379007-11-michal.wilczynski@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
        <20221107181327.379007-11-michal.wilczynski@intel.com>
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

On Mon,  7 Nov 2022 19:13:26 +0100 Michal Wilczynski wrote:
> Add documentation to a newly added devlink-rate feature. Provide some
> examples on how to use the features, which netlink attributes are
> supported and descriptions of the attributes.

> +Devlink Rate
> +==========
> +
> +The ``ice`` driver implements devlink-rate API. It allows for offload of
> +the Hierarchical QoS to the hardware. It enables user to group Virtual
> +Functions in a tree structure and assign supported parameters: tx_share,
> +tx_max, tx_priority and tx_weight to each node in a tree. So effectively
> +user gains an ability to control how much bandwidth is allocated for each
> +VF group. This is later enforced by the HW.
> +
> +It is assumed that this feature is mutually exclusive with DCB and ADQ, or
> +any driver feature that would trigger changes in QoS, for example creation
> +of the new traffic class.

Meaning? Will the devlink API no longer reflect reality once one of 
the VFs enables DCB for example? 

> This feature is also dependent on switchdev
> +being enabled in the system. It's required bacause devlink-rate requires
> +devlink-port objects to be present, and those objects are only created
> +in switchdev mode.
> +
> +If the driver is set to the switchdev mode, it will export
> +internal hierarchy the moment the VF's are created. Root of the tree
> +is always represented by the node_0. This node can't be deleted by the user.
> +Leaf nodes and nodes with children also can't be deleted.
> +
> +.. list-table:: Attributes supported
> +    :widths: 15 85
> +
> +    * - Name
> +      - Description
> +    * - ``tx_max``
> +      - This attribute allows for specifying a maximum bandwidth to be

Drop the "This attribute allows for specifying a" from all attrs.

> +        consumed by the tree Node. Rate Limit is an absolute number
> +        specifying a maximum amount of bytes a Node may consume during
> +        the course of one second. Rate limit guarantees that a link will
> +        not oversaturate the receiver on the remote end and also enforces
> +        an SLA between the subscriber and network provider.
> +    * - ``tx_share``

Wouldn't it be more common to call this tx_min, like in the old VF API
and the cgroup APIs?

> +      - This attribute allows for specifying a minimum bandwidth allocated
> +        to a tree node when it is not blocked. It specifies an absolute
> +        BW. While tx_max defines the maximum bandwidth the node may consume,
> +        the tx_share marks committed BW for the Node.
> +    * - ``tx_priority``
> +      - This attribute allows for usage of strict priority arbiter among
> +        siblings. This arbitration scheme attempts to schedule nodes based
> +        on their priority as long as the nodes remain within their
> +        bandwidth limit. Range 0-7.

Nodes meaning it will (W)RR across all nodes of highest prio?

Is prio 0 or 7 highest?

> +    * - ``tx_weight``
> +      - This attribute allows for usage of Weighted Fair Queuing
> +        arbitration scheme among siblings. This arbitration scheme can be
> +        used simultaneously with the strict priority. Range 1-200.

Would be good to specify how the interaction with SP looks.
Does the absolute value of the weight matter or only the relative
values? (IOW is 1 vs 10 the same as 10 vs 100)
