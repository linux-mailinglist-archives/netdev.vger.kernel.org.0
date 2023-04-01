Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465AE6D2E4A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 07:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjDAFHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 01:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjDAFHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 01:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49047EFBF
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 22:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEEC609D1
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E4C433EF;
        Sat,  1 Apr 2023 05:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680325641;
        bh=givyGftIZji3GuGv81w4VoqK50FcNFfeyJkKlV7h6Go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LzRcPzCWMgnwMrpr1q50Ffz+bmLgOibNNRFgmz3tT3SJQ000IXR32t9knLlJg2GHM
         ka0Kv+FRDaZhPAN2B0pvaSEKbHP90UEVI8ucFudQrzItSa48Os+OvSCkaUsV2xEa/5
         FpaO2XKxV/9JoiQFY3aQmvXLFkb7qDftSjPZBgk0pbSnTBMKtsRfaHdopicDdR/sar
         zx/9BSTmqIGXfwRUpLJi0pn43KHdoDbdXnG2Pc8BeI2cF/aQmGS6qy9bYKO5g61yRC
         gaCc0ezdaoe16OSYSmvd1QLY5PQH8vJczZAaEnsePg3HqHWFqMm5g2Q/7I7hR2XV1D
         Vk7yh3CJebGhg==
Date:   Fri, 31 Mar 2023 22:07:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <brett.creeley@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <drivers@pensando.io>, <leon@kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [PATCH v8 net-next 05/14] pds_core: set up device and adminq
Message-ID: <20230331220719.60bb08f3@kernel.org>
In-Reply-To: <20230330234628.14627-6-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
        <20230330234628.14627-6-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 16:46:19 -0700 Shannon Nelson wrote:
> +	listlen = fw_list.num_fw_slots;
> +	for (i = 0; i < listlen; i++) {
> +		snprintf(buf, sizeof(buf), "fw.%s",
> +			 fw_list.fw_names[i].slotname);
> +		err = devlink_info_version_stored_put(req, buf,
> +						      fw_list.fw_names[i].fw_version);
> +	}

Keys must be enumerated in the kernel, no copying directly from 
the FW please.

Also it'd be a little easier to review if the documentation was part 
of the same patch as code :(
