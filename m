Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA85A1934E8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgCZAOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:14:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44682 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgCZAOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 20:14:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id x16so3874232qts.11;
        Wed, 25 Mar 2020 17:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S7Sc2duj77D7JUnGMQoCkHU904ydcBEnNRzF9FLm+YI=;
        b=RlP8ohqHvEQkTK5kGgiSBl6WH15PaVWtiHB0v1Iv/6+Vfb7Eka28N35XydaiEqMzR/
         jyu0O0ohpyMxX4ljdq7uAa05nGe/pUIyNc9EcCYEbxQw9WHup+M3MJlOoqNaH7GaJ2yj
         IIL3xL3riXneubS0jgb8qcUWmvFUyfQDfxyG8dEmm56J0BIvzPHd9zdvAocR0scnEneT
         ytPm34ox8nq05DzF6Ndfs7FOgsEZUd5mtuxinmQv/6KP2RC9XOVR3AE081hTqJaNTNcC
         SwPCUuoNv6teuL1fTt1fk5V6SCKAiCa9FQmkBJahwk8h5XoEJOdj7j1iApionCMf+WdI
         VOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S7Sc2duj77D7JUnGMQoCkHU904ydcBEnNRzF9FLm+YI=;
        b=JeN73LHIHRj/Ot6qfymUEkqFZCOq8Z1sowgVqkWna2PPHAmrKStznoh/YpIYlkJSEy
         VjZ3FlXTUoYGJCp2XW0y/3Ucf8FcHOiu2Lgmc5sfhsCndulgvXEW8en3PmEbg6aRamhH
         bUlIsgeu5qLOXapdShMfOWdJi+bFEIpApoFoA9xf98gxDLKsqbKyaO/ghEkWzyMF1Sz/
         FMpgp0dO4TAfy3PcIfjw++ON2iRpQFYauLKunrXR8n7CxP8rC1lhVb6jfMMmk0NuBe2C
         yoektX9YOA4PeaZ1IcESiZ731A9cxAdUrM3he/rt7n512ftSRZAP8TGS4jFNkBOnBNqM
         PwmA==
X-Gm-Message-State: ANhLgQ2Lyeh0qNteFNqizwUPyRW6B6J3lys4fjq5+SoSdnBpzk2Z7EKo
        q524Aw5g0AXLlLhDtTjM4zU=
X-Google-Smtp-Source: ADFU+vvK1RIyUK2HbSXkLR4unarSaVy6joaX5gpk8/f4lhxjrE6nMTj7npVg5cJ/aI0GxF+KKR9pDQ==
X-Received: by 2002:ac8:568b:: with SMTP id h11mr4420271qta.105.1585181659543;
        Wed, 25 Mar 2020 17:14:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:d8e3:b319:cf5:7776:b4d9])
        by smtp.gmail.com with ESMTPSA id 82sm340437qkd.62.2020.03.25.17.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 17:14:18 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4C55BC5CE4; Wed, 25 Mar 2020 21:14:16 -0300 (-03)
Date:   Wed, 25 Mar 2020 21:14:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200326001416.GH3756@localhost.localdomain>
References: <20200322090425.6253-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322090425.6253-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> sctp_sock_migrate should iterate over the datamsgs to modify
> all trunks(skbs) to newsk. For this, out_msg_list is added to

s/trunks/chunks/

> sctp_outq to maintain datamsgs list.

It is an interesting approach. It speeds up the migration, yes, but it
will also use more memory per datamsg, for an operation that, when
performed, the socket is usually calm.

It's also another list to be handled, and I'm not seeing the patch
here move the datamsg itself now to the new outq. It would need
something along these lines:
sctp_sock_migrate()
{
...
        /* Move any messages in the old socket's receive queue that are for the
         * peeled off association to the new socket's receive queue.
         */
        sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
                event = sctp_skb2event(skb);
...
                /* Walk through the pd_lobby, looking for skbs that
                 * need moved to the new socket.
                 */
                sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
                        event = sctp_skb2event(skb);

That said, I don't think it's worth this new list.

  Marcelo
