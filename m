Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF43C67A8E0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjAYCjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjAYCj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:39:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60A54B766
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BC9B81887
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B562C433EF;
        Wed, 25 Jan 2023 02:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674614366;
        bh=DQ3B2SoLAM1KE81ALXEmHiSkp79HK3aMMrCgN+pdHJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XvwYpVGx2E0jCvtGgT3mc1bmGURRq6lZ0uUk3hBt9ztttgjbyaV0Ds4USH0vClSDZ
         wUmMgYkey9hi1hOqww9Dk+LUzAajSPY4ko+aiGvddknZHOY9koOASvN0AEBtPAEKum
         kavL8Ucf2/gauK1ngf/1gp+hBySdKbKGoSuitVw+4z+znXAm/86v0ermr5G9i6H7UW
         rN/k60aTkoCqnHkdwxvYOUjpHB9OCBC5RMz2WQJUh9/gqLqR+yZbZV5/dDhtouc66C
         adBnVnFbyEByzYF71ssmr+8dpO9sA/sb7B64GwDYVyFX/oaEErsnCgmYHBUakHpGRW
         WR/C8hAaKW2pw==
Date:   Tue, 24 Jan 2023 18:39:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Toggle between queue types in
 affinity mapping
Message-ID: <20230124183925.257621e8@kernel.org>
In-Reply-To: <20230123221727.30423-1-nnac123@linux.ibm.com>
References: <20230123221727.30423-1-nnac123@linux.ibm.com>
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

On Mon, 23 Jan 2023 16:17:27 -0600 Nick Child wrote:
> A more optimal algorithm would balance the number RX and TX IRQ's across
> the physical cores. Therefore, to increase performance, distribute RX and
> TX IRQs across cores by alternating between assigning IRQs for RX and TX
> queues to CPUs.
> With a system with 64 CPUs and 32 queues, this results in the following
> pattern (binding is done in reverse order for readable code):
> 
> IRQ type |  CPU number
> -----------------------
> TX15	 |	0-1
> RX15	 |	2-3
> TX14	 |	4-5
> RX14	 |	6-7

Seems sensible but why did you invert the order? To save LoC?
