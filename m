Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10224542218
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbiFHGBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244650AbiFHFzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3EE43DE12
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 21:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5C9618FF
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731AC3411D;
        Wed,  8 Jun 2022 04:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654661425;
        bh=k1oJOtG5LuR82UtUOrNZoYrSbRdkaEwlZMO/OY6JNL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fSwypEJNEd59G9Dpp/rcuWWXFwFFzJxLOWUWBtSMQR+OEDgzIyd8mQBZdZRTEePxg
         +s8XF4RZfN2tgt9dH7O5Q/P8tNvGzM7vOQbn/h7ZlIOhorWlKapYEqNxI5syFS9StW
         Wjdx1s/ge0ATewwiT6JmycVLMPrcqnsghVCr5OkOSZU52D9zwyqVVwO/bz53Cekfiu
         IZyOzgCJaFaRt44UMxzTuBo+q1WPVbIUrm026CNAIc33g2v7eDfvitaRkrBS77/is5
         Y9VGryLDeVtz3FBJgsLrgVyBvq51b+DowDWVPuuvw5UzniOQk9zVFOh7NeccAe6nOu
         T2Cmu6/Cdge+g==
Date:   Tue, 7 Jun 2022 21:10:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 4/8] net: use DEBUG_NET_WARN_ON_ONCE() in
 sk_stream_kill_queues()
Message-ID: <20220607211023.33a139b2@kernel.org>
In-Reply-To: <20220607171732.21191-5-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
        <20220607171732.21191-5-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jun 2022 10:17:28 -0700 Eric Dumazet wrote:
> sk_stream_kill_queues() has three checks which have been
> useful to detect kernel bugs in the past.
> 
> However they are potentially a problem because they
> could flood the syslog, and really only a developper
> can make sense of them.
> 
> Keep the checks for CONFIG_DEBUG_NET=y builds,
> and issue them once only.

I feel like 3 & 4 had caught plenty of bugs which triggered only 
in production / at scale. In my head DEBUG_NET_WARN_ON_ONCE() is 
great for things we are relatively sure syzbot will trigger.
Am I mis-characterizing things or should we WARN_ON_ONCE() those?
