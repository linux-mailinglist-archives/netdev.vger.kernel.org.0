Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05736C6E35
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjCWQ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjCWQ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:57:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532F7B5;
        Thu, 23 Mar 2023 09:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C982B812A5;
        Thu, 23 Mar 2023 16:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771A7C433EF;
        Thu, 23 Mar 2023 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679590657;
        bh=mInJnjBlglGuGfIDOgknpNJ8Ke8sxSP3MjH3m6CZZaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qx35hCZFUARJfcBigrOo5+QSFYgorxH9byIi96D7oL1W6PwHnhRFcFOLqvgEZfe6N
         rsPoqz2ojlfCRz6p+LewOsvFAGzCsbkSJVd8C64Eqvr7rqYeKiLg7mwpgcgIN3frSV
         x4bzsCImaH39c5dxfLYo0J7yavWkJ4ILiGayHVIqDt2vy6MTVApNJuayU52ONBUHdM
         Kdtq9R0110dXl8qD4JDb8FZ/Vvc1/Lwg6fIg5YxZuFBfu1pLtlbccKMUvwcl/fgvsx
         5+BuwFBmuP8SgZsxJv0wjix/umYbK6+Pl0V4jxWBAod7j0JtEQXo5rJ2w38801d3qs
         ncVoDiXxGCNxw==
Date:   Thu, 23 Mar 2023 09:57:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH mfd-n 2/2] mfd: rsmu: support 32-bit address space
Message-ID: <20230323095736.38ea1ca8@kernel.org>
In-Reply-To: <MW5PR03MB69320CC31AB6206419DFF2C9A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
References: <20230323161518.14907-1-lnimi@hotmail.com>
        <MW5PR03MB69320CC31AB6206419DFF2C9A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 12:15:18 -0400 Min Li wrote:
> -	u8 cmd[256] = {0};
> -	u8 rsp[256] = {0};
> +	u8 cmd[RSMU_MAX_READ_COUNT + 1] = {0};
> +	u8 rsp[RSMU_MAX_READ_COUNT + 1] = {0};
>  	int ret;
>  
> +	if (bytes > RSMU_MAX_READ_COUNT)
> +		return -EINVAL;

Why is defining the constant to MAX_READ and checking the requested
size part of this patch, the commit message only talks about addresses
operation size is not mentioned in any way...
