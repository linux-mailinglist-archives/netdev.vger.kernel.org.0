Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF066B526C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjCJU7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCJU7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1CF146256
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 12:57:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E820B82404
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 20:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856A1C433EF;
        Fri, 10 Mar 2023 20:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678481801;
        bh=NOAqoXSGcUkxUK5JI9uVomL9Z3ne1SJq24sTY1TvxBM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tGk4JYvWL4j2DC+XxxQ5Xat8Y6pwuRa6qHg+Pxu+yFxl8lSC+xKJO9aD67y6GAdsq
         HmSliebVTe2cXSdvEu1Y63VT9xuuzKSxERbVv6lS9SiYCGzPM7Q04U5aF/Q+9NV2KZ
         skxA0cTD0eyuuPO+KjpEmRwhwf+rP1mJOXJbpVo8T8SZJpBR8bKTa0z33ixzDCBD2i
         lO5WHzZ9FNjENaWzlAz1gjmY+g4vhT7O1U+taaAuYMr3C9C/eB7iwC3lCYZhaXJlX7
         KgZnc29gC1j7Du3QJXf794QypCev/MP3HnOzpv4BlOzGusYUgHjPYTnVNLr6YJ4etE
         WJ7LkeX8pw+rA==
Date:   Fri, 10 Mar 2023 14:56:40 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 1/6] r8169: use spinlock to protect mac ocp register
 access
Message-ID: <20230310205640.GA1278373@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9508a76f-8f83-9579-a46f-742d486a6cac@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 10:44:10PM +0100, Heiner Kallweit wrote:
> For disabling ASPM during NAPI poll we'll have to access mac ocp
> registers in atomic context. This could result in races because
> a mac ocp read consists of a write to register OCPDR, followed
> by a read from the same register. Therefore add a spinlock to
> protext access to mac ocp registers.

protect
