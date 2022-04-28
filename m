Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29A5513488
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiD1NJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiD1NJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF85B0A69;
        Thu, 28 Apr 2022 06:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E753962060;
        Thu, 28 Apr 2022 13:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01CEC385A9;
        Thu, 28 Apr 2022 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651151190;
        bh=Y2mgIYqiJCbEdpTzl4SkhzveN8LLuSbvl2n9IvPySbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X9otxRXFG2oqra98rIV0acvFsPgxXPMi7z+0a9DIrKpwjipjnYCXRSVI1HOg4xlc7
         1I2aM6P7GizExQz4gtNYAJhv3+JP/EoLNs86HCrvwgmcvahMRv9k8UuTACJrGWDYf5
         5lMsN5c2fYZ8GWIq911R2idB/vc14ekuvwo7mvVBRziU4UzH+Vx9SLW57J9vBYpX/x
         MtAPCcjo7OXz1mAKyHqR5uLhEFswCSOuIKFInnhOXXzEpF2GWb71siUmiuqXS3+Yn3
         OHLfvinMRnkosL+JgpA5o87sdWee+dwIjEYKceRv2JYbfs4zEtZSl5WK5gES3xvrCj
         qyHhgK65+7YvQ==
Date:   Thu, 28 Apr 2022 06:06:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lin Ma <linma@zju.edu.cn>, Duoming Zhou <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
Message-ID: <20220428060628.713479b2@kernel.org>
In-Reply-To: <YmpcUNf7O+OK6/Ax@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
        <20220427174548.2ae53b84@kernel.org>
        <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
        <YmpEZQ7EnOIWlsy8@kroah.com>
        <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
        <YmpNZOaJ1+vWdccK@kroah.com>
        <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
        <YmpcUNf7O+OK6/Ax@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 11:20:16 +0200 Greg KH wrote:
> > The added dev_register variable can function like the original
> > device_is_registered and does not race-able because of the
> > protection of device_lock.  
> 
> Yes, that looks better, but what is the root problem here that you are
> trying to solve?  Why does NFC need this when no other subsystem does?

Yeah :( The NFC and NCI locking is shaky at best, grounds-up redesign
with clear rules would be great... but then again I'm not sure if anyone
is actually using this code IRL, so the motivation to invest time is
rather weak.
