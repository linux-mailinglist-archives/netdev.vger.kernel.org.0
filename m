Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F176608C3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbjAFVUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbjAFVUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:20:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB1F82F52
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D8F7B81ECF
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 21:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04FFC433D2;
        Fri,  6 Jan 2023 21:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673039975;
        bh=YenTKy2p3fC5xn+5Zc7CPkpCvHxZc8M6BozRdWsWSAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N22xN0KIPWu54R4EeWskH03Yxk1+JwhXJhlwQOoMI9XgVpmD5JmtTuej/kSkHWwcX
         pDfui1TTcNVvQU/y80Lg2sW/hep/52irX9xYfHlANlKw7YTWCYyEwFrXIOHkORKHFF
         BM7iFahBXu9/2G4ofBAM8ychYp3F3U5TKvzAfR0peVUB8jKkoIPMpgaJt21c3q4mRp
         Iuw3EmOQHROcTGz8FQpABF3kkWEmQZPM1YhDWJsaCe10Xc0qcxMl/cjT4oDlHTYVZK
         +UChPaIc0TPLS+nzTh6XC+TCRYueDKv1TSfPxc2gD7W2HjhJRN5q9D2DoATjeCfZH+
         ycnA40Eu+4WkA==
Date:   Fri, 6 Jan 2023 13:19:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next 4/9] devlink: always check if the devlink
 instance is registered
Message-ID: <20230106131934.14e7a900@kernel.org>
In-Reply-To: <9f408a8c-4e23-9de5-0ee8-5deccd901543@intel.com>
References: <20230106063402.485336-1-kuba@kernel.org>
        <20230106063402.485336-5-kuba@kernel.org>
        <9f408a8c-4e23-9de5-0ee8-5deccd901543@intel.com>
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

On Fri, 6 Jan 2023 09:03:18 -0800 Jacob Keller wrote:
> > +static inline bool devl_is_registered(struct devlink *devlink)
> > +{
> > +	/* To prevent races the caller must hold the instance lock
> > +	 * or another lock taken during unregistration.
> > +	 */  
> 
> Why not just lockdep_assert here on the instance lock? I guess this
> comment implies that another lock could be used instead but it seems
> weird to allow that? I guess because of things like the linecards_lock
> as opposed to the instance lock?

Yup, as discussed on the RFC - removing the regions lock specifically 
is quite tricky.
