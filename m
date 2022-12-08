Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3C646728
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHClq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLHClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:41:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7D950C7
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24E59B821FF
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6179C433C1;
        Thu,  8 Dec 2022 02:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670467266;
        bh=94jDSpUU8Q3Y/bToX3ieE98xeDC5cMOi+I6fdmiKH4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YXvs7bBFu1NYfn9ELTWVtFYd2HIgAk2c2dLJxLIb4WwBE826Ni7RYoyLU1ZpF3CSj
         VEzsZZscg098YVWls3RR7Ehuv46uMow9NFn9wukLZYRNkLGDIVQQobGsKG4QQ7TcBU
         cS3xC9cVi1HITHS/aODUcUs3F6g3xpjNTaxa+iitrlFhVxGcz4BSm1ozZ/b4yKd39i
         iEAaigUXfMSSD33Nmeo6k/RkssvV1Y1b55dTBFZagV+Sv2h+EJnOZWII4KdXNWuELT
         f49pEkaE/UQkT86lPDxrw7BqeqPYArlLLYYZUxy89lN+0EShLYbqJPoKHJqNAws1Ab
         oVhTfjgouozcQ==
Date:   Wed, 7 Dec 2022 18:41:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v1 1/2] ethtool/uapi: use BIT for bit-shifts
Message-ID: <20221207184105.74dfdd1c@kernel.org>
In-Reply-To: <20221207231728.2331166-2-jesse.brandeburg@intel.com>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
        <20221207231728.2331166-2-jesse.brandeburg@intel.com>
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

On Wed,  7 Dec 2022 15:17:27 -0800 Jesse Brandeburg wrote:
>  #define ETH_RSS_HASH_TOP	__ETH_RSS_HASH(TOP)
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 58e587ba0450..6ce5da444098 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -9,6 +9,7 @@
>   *                                christopher.leech@intel.com,
>   *                                scott.feldman@intel.com)
>   * Portions Copyright (C) Sun Microsystems 2008
> + * Portions Copyright (C) 2022 Intel Corporation

Is that appropriate?

> +/* BIT() and BIT_ULL() are defined in include/linux/bits.h but we need a
> + * local version to clean up this file and not break simultaneous
> + * kernel/userspace where userspace doesn't have the BIT and BIT_ULL
> + * defined. To avoid compiler issues we use the exact same definitions here
> + * of the macros as defined in the file noted below, so that we don't get
> + * 'duplicate define' or 'redefinition' errors.
> + */
> +/* include/uapi/linux/const.h */
> +#define __AC(X,Y)	(X##Y)
> +#define _AC(X,Y)	__AC(X,Y)
> +#define _AT(T,X)	((T)(X))
> +#define _UL(x)		(_AC(x, UL))
> +#define _ULL(x)		(_AC(x, ULL))
> +/* include/vdso/linux/const.h */
> +#define UL(x)		(_UL(x))
> +#define ULL(x)		(_ULL(x))
> +/* include/vdso/bits.h */
> +#define BIT(nr)		(UL(1) << (nr))
> +/* include/linux/bits.h */
> +#define BIT_ULL(nr)	(ULL(1) << (nr))

include/uapi/linux/const.h
