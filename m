Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEF3651524
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiLSVzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiLSVzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:55:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EEFBB2
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 13:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9CE61165
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 21:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074D1C433D2;
        Mon, 19 Dec 2022 21:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671486943;
        bh=iJtibprj1PmGpxkWfGJu2UJYq7KwmSzm7bCQFlSBjvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cTEeV+X+nTRZKx2jC8ZFDVLtzPHom0+53bZXo3N+VWm6yJlrLnOOiUrEih0TqN0qG
         e5S9msr7ChqOj05vjxJH4tE68Z5jVQfkADMLk5FPcfr13oYOtEdr5AlY7FZIgblq61
         +fDggQcxAitoBDjK5UBjJulWYgP6CEx5E83S37SNFmzXZMqCSaRQ1qXrqfaHMUCxzW
         TJiQMBlmAJ15muuAhsSwtZ105rHPPO7ZFoiBqx8xM8BKp8Fgsp56cf6Bv0dPToYkz5
         +8RQE4oB/B4M79N5Y54MFI3dtW43SJO/cLBy66tp9Rq4Y+bMa+FUNOWWf4/9YIwdt4
         GNaai3guoHkoA==
Date:   Mon, 19 Dec 2022 13:55:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <20221219135541.6e0a7cfd@kernel.org>
In-Reply-To: <84151471-4404-d944-417f-2982569f44da@intel.com>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-5-kuba@kernel.org>
        <84151471-4404-d944-417f-2982569f44da@intel.com>
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

On Mon, 19 Dec 2022 09:48:54 -0800 Jacob Keller wrote:
> On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> > Always check under the instance lock whether the devlink instance
> > is still / already registered.
> 
> Ok. So now the reference ensures less about whats valid. It guarantees a
> lock but doesn't ensure that the devlink remains registered unless you
> acquire the lock and check that the devlink is alive under lock now?

Correct.

> > This is a no-op for the most part, as the unregistration path currently
> > waits for all references. On the init path, however, we may temporarily
> > open up a race with netdev code, if netdevs are registered before the
> > devlink instance. This is temporary, the next change fixes it, and this
> > commit has been split out for the ease of review.
> >   
> 
> This means you're adding the problem here, but its fixed in next commit..?

Yes, I can squash when posting for applying, but TBH I think the clarity
of the changes outweighs the tiny and transient race.
