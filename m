Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9221F603833
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJSCrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJSCrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8030F7DF68
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C410615FD
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 02:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFACC433C1;
        Wed, 19 Oct 2022 02:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666147653;
        bh=8V1/pYP2gowpe+s/XT682CTKnH8eXrJHgCK2to9HZ/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rFfV2nhiQs9T3VNQ8zFjwTBcLQiUdmF0J3HhkmUb8Fe7lehPMfbSO7KC0A/sy9xdN
         4omT1GspZgOCDozy1HN0LyNHNiWPv+8JkxGJrHoKB3D2lYcb6OwImE7NhRdFrCAZ/M
         3dDnd539MMbaz3Iq/RoA1Z+3IEMduQDyLHx5hIRQWSfn2EhrTfBQB4JV7BqvGAgOCG
         /r7hFyynbxjHyBbARARnhCDW2EpH9QghwrraH2CxKp41Xqvz7ton/9K7NgeNeDc+pg
         j3CGkYpJaeR4ihVnCNGGbO08e0IHHc21q/zGYLQpXtDq1gFy75SR8UuU1l3Y1Xu/v5
         4mjPBL0x7OV0g==
Date:   Tue, 18 Oct 2022 19:47:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: Re: [PATCH net-next v3 2/5] ptp: ocp: add Orolia timecard support
Message-ID: <20221018194732.16f7d413@kernel.org>
In-Reply-To: <20221018090122.3361-3-vfedorenko@novek.ru>
References: <20221018090122.3361-1-vfedorenko@novek.ru>
        <20221018090122.3361-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 12:01:19 +0300 Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> This brings in the Orolia timecard support from the GitHub repository.
> The card uses different drivers to provide access to i2c EEPROM and
> firmware SPI flash. And it also has a bit different EEPROM map, but
> other parts of the code are the same and could be reused.

> +static const struct ocp_attr_group art_timecard_groups[];
> +static const struct ocp_sma_op ocp_art_sma_op;

Clang is not on board:

drivers/ptp/ptp_ocp.c:384:32: warning: tentative definition of variable with internal linkage has incomplete non-array type 'const struct ocp_sma_op' [-Wtentative-definition-incomplete-type]
static const struct ocp_sma_op ocp_art_sma_op;
                               ^
drivers/ptp/ptp_ocp.c:349:15: note: forward declaration of 'struct ocp_sma_op'
        const struct ocp_sma_op *sma_op;
                     ^

You may need to throw an extern in there.

Is it not possible to just order things correctly in the first place? 
Is there a dependency cycle?
