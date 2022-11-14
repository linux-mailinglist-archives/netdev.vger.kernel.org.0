Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D499628135
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiKNNYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNNYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:24:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72267276
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1623F61194
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 13:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D86FC433D6;
        Mon, 14 Nov 2022 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668432238;
        bh=wnpm2NS18rFbBEvcB3KHijozvFClc8bbydDGjrnn9c8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtTwazV4c5DKoHkz7x3vGPuCKSxlYnU6Sx8SA7P/S+nXh3YlvQMkDP8CVRmk34FR6
         tfPEcYnaHmc4OJKYwO9yR4lYO3/KhLY/nBQYlT2sANSl6H0ZoPFnljuTYZP89eMzDu
         +DviOctPjqwLCaJWXx8nNL8fwrB78laB8xn+ljVWN5zfLrTcvnrH/muEn9Z0LdFDzt
         sCKYIlNjDkvvV+FGonz/h3hKh+/SANVzAjRVogRc83xt/QmlKi+YOSHC2v8830FYnJ
         oM30yxJYhA2if6I0WLMxWOup4hUwzj2QZTuPDXMvYLoLFB0uebjAJcgEer7fzz9GDr
         2eCNoHK9dkthA==
Date:   Mon, 14 Nov 2022 15:23:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3JBaQ7+p5ncsjuW@unreal>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> Currently the default value for number of PF vectors is number of CPUs.
> Because of that there are cases when all vectors are used for PF
> and user can't create more VFs. It is hard to set default number of
> CPUs right for all different use cases. Instead allow user to choose
> how many vectors should be used for various features. After implementing
> subdevices this mechanism will be also used to set number of vectors
> for subfunctions.
> 
> The idea is to set vectors for eth or VFs using devlink resource API.
> New value of vectors will be used after devlink reinit. Example
> commands:
> $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> $ sudo devlink dev reload pci/0000:31:00.0
> After reload driver will work with 16 vectors used for eth instead of
> num_cpus.

By saying "vectors", are you referring to MSI-X vectors?
If yes, you have specific interface for that.
https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/

Thanks
