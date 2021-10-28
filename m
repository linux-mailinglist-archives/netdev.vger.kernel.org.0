Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CDC43E478
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhJ1PBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhJ1PBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:01:31 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31321C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:59:04 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l186so6619797pge.7
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o7fbEddlaArCK/o3VPdQ2D4e4Wzu9cRDAt0j3CtTkw0=;
        b=Kis4jG6WDJoMIl3hlQygYZV3AqomWI/WNK+Gq57ozbTc1kBf0MhF2PgythHM+qQpIF
         xUEEdJyxxIN8fWiy98pbLcL5q29IUSS6jQoRr7wVzZTwwuWj9DmyNbAM8PpEfeYq5KJG
         OnrLyZrZI5q1PAy/EWcjv0ek8WqHqCuRyvEn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o7fbEddlaArCK/o3VPdQ2D4e4Wzu9cRDAt0j3CtTkw0=;
        b=dGEXtmvE6WNCMd74aSWdDqSMi1vSZ18heDEbcRF8JejF+PwFfRqh1G3+tBd4gAnfRR
         syCHJQgpJUsV30ODLzdr1RsoiOZzPWJ1F/JJFCfNTujNuPFL6NxYBWZlle0BAQP032eE
         8V7UgPofXua/WNY797bL/zNiio9Xq4r00+fxyLlSZkPw0yq0K33k1N0va4XDTMusKYYw
         El7aotebkmK24C0Rsr6KysE0MyL7EwpX3bfzAfGhUQP/KvWf4kXa9+YqONFHy18wDgYV
         CfIjvOO4BNuTNFAh2HeDDwSa5SiHUuBp9zaUW0kfpBb4AkQCLpJcRUNBtMMuZ4+v4zvo
         W5Xg==
X-Gm-Message-State: AOAM532MPTgo+YCr3Oic/rfYkGnuFIJ3Dohmpa4QqNOaEPhJ7RXSq9rY
        6mSicwd1GL17FJpbUwvtalv2Zw==
X-Google-Smtp-Source: ABdhPJwX4ub8k+DjqMfHllcKU3GYPAHLa8XbhOPm7Dy35s2fSozYyCYNRcZ0Fd0sL0cTtvWUWmiBYA==
X-Received: by 2002:a05:6a00:24c5:b0:47c:2094:e16a with SMTP id d5-20020a056a0024c500b0047c2094e16amr4875323pfv.54.1635433143722;
        Thu, 28 Oct 2021 07:59:03 -0700 (PDT)
Received: from cork (c-73-158-250-94.hsd1.ca.comcast.net. [73.158.250.94])
        by smtp.gmail.com with ESMTPSA id d6sm3722138pfa.39.2021.10.28.07.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:59:03 -0700 (PDT)
Date:   Thu, 28 Oct 2021 07:59:01 -0700
From:   =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Caleb Sander <csander@purestorage.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] Re: [PATCH] qed: avoid spin loops in
 _qed_mcp_cmd_and_union()
Message-ID: <YXq6tTWTdiSPM/wr@cork>
References: <20211027214519.606096-1-csander@purestorage.com>
 <d9d4b6d1-d64d-4bfb-17d9-b28153e02b9e@gmail.com>
 <CADUfDZqx6EjOY=JcQuC6hfPjGgTZCk6BcV5_D1Dp+WQJiXmEnQ@mail.gmail.com>
 <PH0PR18MB465585F216AEC6E441B7E0E4C4869@PH0PR18MB4655.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR18MB465585F216AEC6E441B7E0E4C4869@PH0PR18MB4655.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 05:47:10AM +0000, Ariel Elior wrote:
>
> Indeed this function sends messages to the management FW, and may
> be invoked both from atomic contexts and from non atomic ones.
> CAN_SLEEP indicated whether it is permissible in the context from which
> it was invoked to sleep.

That is a rather unfortunate pattern.  I understand the desire for code
reuse, but the result is often to use udelay-loops that can take
seconds.  In case of unresponsive firmware you tend to always hit the
timeouts and incur maximum latency.

Since the scheduler is blocked on the local CPU for the time of the spin
loop and won't even bother migrating high-priority threads away - the
assumption is that the current thread will not loop for a long time -
the result can be pretty bad for latency-sensitive code.  You cannot
guarantee any latencies below the timeout of those loops, essentially.

Having a flag or some other means to switch between sleeping and
spinning would help to reduce the odds.  Avoiding calls from atomic
contexts would help even more.  Ideally I would like to remove all
such calls.  The only legitimate exceptions should be those handling
with high-volume packet RX/TX and never involve long-running loops.
Anything else can be handled from a kworker or similar.  If a 1s loop is
acceptable, waiting a few ms for the scheduler must also be acceptable.

Jörn

--
If a problem has a hardware solution, and a software solution,
do it in software.
-- Arnd Bergmann
