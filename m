Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09D6526831
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381006AbiEMRVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348016AbiEMRVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:21:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A952B0B;
        Fri, 13 May 2022 10:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D10A9B82E1E;
        Fri, 13 May 2022 17:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F88AC34100;
        Fri, 13 May 2022 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652462507;
        bh=0Z+7A9FB8DvG9yJt2Qo5SF8MJS2WO1YD33FgZbNZGno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QvuV4CdZFIrIYLgtATdayymaKKNgXmGt9t6aFvX0wkXyo3/Oaqjbht1IMBE6zxR59
         YRSHsnjuwRCA50SiCGDm+IvWnNZFLVIam7rLoUEOgpugh0tMu7h6IFxHvIzWZDvNWm
         6X1Ai75tH+RN4WsqU5ilgj4goxEGR7luzInCKwNqpgSq0Kd31hh4S7LWC1gcpRNBup
         Cog6etw5C+nWop6GuiVE6SK/FOBhtbm2xuLwDH8R+2xennsDP7l7VBwpjrgchOJBGg
         8Uz3xWLmWHX1cfqIb7ePqDmDc1fz1pZTJZPoZ6kymv2st4QtzonE4nv+shDSloiFJq
         Kof+V2RMb3eYg==
Date:   Fri, 13 May 2022 10:21:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/2] Revert "can: m_can: pci: use custom bit timings
 for Elkhart Lake"
Message-ID: <20220513102145.748db22c@kernel.org>
In-Reply-To: <20220513130819.386012-2-mkl@pengutronix.de>
References: <20220513130819.386012-1-mkl@pengutronix.de>
        <20220513130819.386012-2-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 15:08:18 +0200 Marc Kleine-Budde wrote:
> From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> 
> This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.
> 
> Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
> Elkhart Lake") broke the test case using bitrate switching.
> 
> | ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
> | ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
> | candump can0 &
> | cangen can1 -I 0x800 -L 64 -e -fb \
> |     -D 11223344deadbeef55667788feedf00daabbccdd44332211 -n 1 -v -v
> 
> Above commit does everything correctly according to the datasheet.
> However datasheet wasn't correct.
> 
> I got confirmation from hardware engineers that the actual CAN
> hardware on Intel Elkhart Lake is based on M_CAN version v3.2.0.
> Datasheet was mirroring values from an another specification which was
> based on earlier M_CAN version leading to wrong bit timings.
> 
> Therefore revert the commit and switch back to common bit timings.
> 
> Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
> Link: https://lore.kernel.org/all/20220512124144.536850-1-jarkko.nikula@linux.intel.com
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
> Reported-by: Aman Kumar <aman.kumar@intel.com>
> Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
> Cc: <stable@vger.kernel.org> # v5.16+
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

nit: the hash in the fixes tag should be:

Fixes: ea4c1787685d ("can: m_can: pci: use custom bit timings for Elkhart Lake")

Do you want to respin or is the can tree non-rebasable?
