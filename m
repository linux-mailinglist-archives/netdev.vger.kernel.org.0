Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA3657D1E4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiGUQrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGUQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA28812D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D50D61E6A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 16:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E543EC3411E;
        Thu, 21 Jul 2022 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658422067;
        bh=7Z8wcUahMUBspHyD78jbkOhauV1v64HjDcpMFQSe2II=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1TnBZxZvVMIpHBdrhr9FU0/XlJrEOA/vnYHB07EdoegXO1UutYoPM0OC4sptWhzq
         U4mFTh7q+APRLBNIqppMW5V2A8+vjfN9aMVdbSSy0MurOqvzeNv/fM5SYak+abjdBe
         JEB5Cbaf7zoroD5rTovAGptoofngVjFk/TjVZyxbhEKQ2rdmw+CdVlBU5ZsvmXdA4x
         iuDN7mAVtVjs18zxDHyWF5bnBWDhVrXBq0oa5C817Mwkja/Ry0tRDY6YxG8SGYvpht
         4Zji1LubQSp2oHyaW2ql4z8vFhg5+29WeSipefAlGE51FO4ZC6C1ftBWV5kHZcZmpK
         NCrbwqtUpQpYw==
Date:   Thu, 21 Jul 2022 09:47:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220721094745.18c1900b@kernel.org>
In-Reply-To: <20220720183433.2070122-2-jacob.e.keller@intel.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 11:34:32 -0700 Jacob Keller wrote:
> +	nla_dry_run = info->attrs[DEVLINK_ATTR_DRY_RUN];
> +	if (nla_dry_run) {
> +		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
> +			NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,
> +					    "flash update is supported, but dry run is not supported for this device");
> +			release_firmware(params.fw);
> +			return -EOPNOTSUPP;
> +		}
> +		params.dry_run = true;
> +	}

Looks over-indented. You can do this, right?

	params.dry_run = nla_get_flag(info->attrs[DEVLINK_ATTR_DRY_RUN]);
	if (params.dry_run &&
	    !(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
		/* error handling */
	}
