Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF776032B4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJRSrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJRSrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E199F363
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 11:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA52616D7
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 18:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F077CC433C1;
        Tue, 18 Oct 2022 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666118850;
        bh=rcP83FNx9s08Z93/KKXGGR4nAULRHyML/YT9nkUSsc4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rbft5tR36gde5iR6ws1CcmNR+W7YxhH8y+JpMjwQAenlWtXo0YEZd7mx/7hgZ3GpA
         uLp7iog/5ELyDrUgl39xsKV4LvwiD4wiCI4dKYzNFpEq0srxqHTua/FM25V594V2Zq
         sy9OovDgNwpmw+/LXGvmA30sE0fC7p2zZYofcMhQhWZPU7Qx/2DpVYY6eTRr0yJGBH
         8Y78eWkdu1dsX/tcBEsW+frTSwmG2Lai30Xeq5SsNTUJ2JaMlWIy+ovoQT0RvMbhMq
         tI/YCDfblSLNUCz9W3noCLsrAfyYwMfeAGiol5+XU2ZpUZdv6Ui6rSQZxe9yzPWCbn
         STIQrRQ11GGow==
Date:   Tue, 18 Oct 2022 11:47:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
Subject: Re: [PATCH net-next] ibmveth: Always stop tx queues during close
Message-ID: <20221018114729.79dbfbe2@kernel.org>
In-Reply-To: <20221017151743.45704-1-nnac123@linux.ibm.com>
References: <20221017151743.45704-1-nnac123@linux.ibm.com>
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

On Mon, 17 Oct 2022 10:17:43 -0500 Nick Child wrote:
> The issue with this approach was that the hypervisor freed all of
> the devices control structures after the hcall H_FREE_LOGICAL_LAN
> was performed but the transmit queues were never stopped. So the higher
> layers in the network stack would continue transmission but any
> H_SEND_LOGICAL_LAN hcall would fail with H_PARAMETER until the
> hypervisor's structures for the device were allocated with the
> H_REGISTER_LOGICAL_LAN hcall in ibmveth_open.

Sounds like we should treat this one as a fix as well?
How far back is it safe to backport?
