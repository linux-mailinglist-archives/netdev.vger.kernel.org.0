Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820CC5E70F1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiIWAy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiIWAy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:54:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6CA4DF34
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 17:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34155B80C95
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9665CC433C1;
        Fri, 23 Sep 2022 00:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663894494;
        bh=Wi0MPT+64sF4IQr8JAkW7IQh+dbaRG6yXeNvXMPyIOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V1hdRLs7hTvTKQDkjaGlDLHj5V9+nmD2EY7TGX0VLqyIWCVIBlvRg21OCZIJ+C3aT
         hrO9RunKKfJohWHSwQDwmqGdiKTqgCq4JTranaFhnrHEeAc5BPibefyaEiRqoGVsQK
         xyszUe/0klrBk4UgLD2GYANDLz00RWzI3A5eJHfjowhyAa5AndzjNwsPPprXsZVOwV
         LwtNiSJIIYHMDjbCukHR1sGifDMNjFVK7lC46orvuog2EaorkcTMEdJ99hsbUz9fgB
         QdLbyy/viz7w31qXSY9qpVNXHQ5bWd6WaVSFMlhdeu+MnGm/3BF7N76fUUk52dYaaF
         pACMGQEhpPAtA==
Date:   Thu, 22 Sep 2022 17:54:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 3/3] nfp: add support restart of link
 auto-negotiation
Message-ID: <20220922175453.0b7057ac@kernel.org>
In-Reply-To: <20220921121235.169761-4-simon.horman@corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-4-simon.horman@corigine.com>
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

On Wed, 21 Sep 2022 14:12:35 +0200 Simon Horman wrote:
> +	err = nfp_port_configure(netdev, false);
> +	if (err) {
> +		netdev_info(netdev, "Link down failed: %d\n", err);
> +		return err;
> +	}
> +
> +	err = nfp_port_configure(netdev, true);
> +	if (err) {
> +		netdev_info(netdev, "Link up failed: %d\n", err);
> +		return err;
> +	}
> +
> +	netdev_info(netdev, "Link reset succeeded\n");
> +	return 0;

This will not do anything if the port is forced up by multi host
or NC-SI.
