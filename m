Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50B66608CD
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbjAFVW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbjAFVW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:22:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7F455B6
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:22:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5AD6B81E0F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 21:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48368C433D2;
        Fri,  6 Jan 2023 21:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673040172;
        bh=vvTtcLoqLCFtCJpjRCawFmNwJAFr43YQ0R50HfWmIRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5r8psYJCH0DewCrUiA/CZN5ILjSjWER/DaovjFmoD2wiEKoF4X9Va05C+LjS4Fb6
         7/mnR2P+H0ONU94htKfWM6U6i72tJhBX57RsCayCWN6LQxqY9rSCKuG9S2d+WVYl02
         F0pBukoGKedMJq0QhGoB1I/cr+qD8PUjQkE79dICaJFCl/SvCO/L+hNmEqmQFOWhVG
         0EkGYqp9l8a363/cXz1OnL0Df9Ynqfiz4yJaWzOSfuU8rh2seGeSBcJbXeF/mUiPUX
         Jy6QWoTmGknIK77I18K31YFDloVMvAeqABaspHID+LxvPAjqnMM2TqVX/uTS/3A9dJ
         HpgB0aJ/3bcCg==
Date:   Fri, 6 Jan 2023 13:22:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters
 after the instance
Message-ID: <20230106132251.29565214@kernel.org>
In-Reply-To: <Y7gaWTGHTwL5PIWn@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
        <20230106063402.485336-8-kuba@kernel.org>
        <Y7gaWTGHTwL5PIWn@nanopsycho>
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

On Fri, 6 Jan 2023 13:55:53 +0100 Jiri Pirko wrote:
> >@@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
> > 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
> > 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
> > 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
> >-	ASSERT_DEVLINK_REGISTERED(devlink);
> >+
> >+	/* devlink_notify_register() / devlink_notify_unregister()
> >+	 * will replay the notifications if the params are added/removed
> >+	 * outside of the lifetime of the instance.
> >+	 */
> >+	if (!devl_is_registered(devlink))
> >+		return;  
> 
> This helper would be nice to use on other places as well.
> Like devlink_trap_group_notify(), devlink_trap_notify() and others. I
> will take care of that in a follow-up.

Alternatively we could reorder back to registering sub-objects
after the instance and not have to worry about re-sending 
notifications :S
