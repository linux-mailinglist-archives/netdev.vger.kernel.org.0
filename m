Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2C621735E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgGGQKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbgGGQKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:10:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D05FC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 09:10:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so20197925pge.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 09:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gYFeciaywwZVNJ2JhjPF19E0O2ITXo/e+JKxgGAJQV4=;
        b=S0ap/BpavwXWeSiJ4ilEv2wxEWyB5HoREiCRdb7Ex+Gbmk5zE1mLYUmw3i3mx0GMmv
         nTsiaq0vePwkLcQIi3uV1RqCy9e+Fbet6D4fFPZgp3G2l85SdXT5ufuA1CzX+T2z0QxE
         oyi1pferoNR1HxZHaovpK4bjw6MI5iZlMKOGkivG80RSCMxHx1HWLJfOcc/HRpFjJNiL
         Zi+ysOZrVChBwbJyHX3GA6XskFBF57dxc7p7SxVgOr6J7cz9CksrOg+Pjo8kUwCsiFqJ
         cofM6elxXyU+HtNMqDaxulEp3GFV0o+tV8FtJhSpqpx5LULzXYaiJGtAMBxqsnMLa6Ie
         BfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gYFeciaywwZVNJ2JhjPF19E0O2ITXo/e+JKxgGAJQV4=;
        b=sR4D9SrdK6Qegrv1vShnDacMssaRJqziQfH9+VVg0036f0K9LS/4dChbwadDRXpiOm
         pdvrsCTL4u79OiyQKoeJo0+PFWvbJhYPJjQCdkkOLlYp52bMu3K3jv54L65BdOH3br7g
         PwFt3JtxZUfJledRVNZVZ6Y4WXO5B21r5guL26LHJvP4c5IvdTF9PvyFla4SraVLdYZO
         37DFa+eONDTSAbYSe648vfDaZt/d4vZ0dxqF1PoQc4SGL8IXFm4UH2uoXU2Q1SlXzkUj
         1fL12cktQUClVbRfnK8ZV1NfUHxlQUwgOpS7U8AqkAlrkrxr+hvVe4l3RJPbexXNzDNw
         WhVQ==
X-Gm-Message-State: AOAM530Bl8T+BrovjV7biPTyWxMx0kVZ07mgFfqmU8MTJuJdytmb6kYF
        WvD1vXfoEFmKd1/jTLyHaTVGnw==
X-Google-Smtp-Source: ABdhPJzWsWXfofOURLCXtFkZV4E94pJSY84gXm1VN5rj014X91FHHh3hBJwCFsYwC62ZFy0sl0Nc2g==
X-Received: by 2002:a63:6ca:: with SMTP id 193mr40758316pgg.269.1594138241201;
        Tue, 07 Jul 2020 09:10:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 204sm11856441pfx.3.2020.07.07.09.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 09:10:39 -0700 (PDT)
Subject: Re: [PATCH net] ionic: centralize queue reset code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200702233917.35166-1-snelson@pensando.io>
 <20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fcb67ff8-2ef8-e5de-1609-2abb4a59a2d2@pensando.io>
Date:   Tue, 7 Jul 2020 09:10:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 10:33 AM, Jakub Kicinski wrote:
> On Thu,  2 Jul 2020 16:39:17 -0700 Shannon Nelson wrote:
>> The queue reset pattern is used in a couple different places,
>> only slightly different from each other, and could cause
>> issues if one gets changed and the other didn't.  This puts
>> them together so that only one version is needed, yet each
>> can have slighty different effects by passing in a pointer
>> to a work function to do whatever configuration twiddling is
>> needed in the middle of the reset.
>>
>> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Is this fixing anything?

Yes, this fixes issues seen similar to what was fixed with b59eabd23ee5 
("ionic: tame the watchdog timer on reconfig") where under loops of 
changing parameters we could occasionally bump into the netdev watchdog.

>
> I think the pattern of having a separate structure describing all the
> parameters and passing that into reconfig is a better path forward,
> because it's easier to take that forward in the correct direction of
> allocating new resources before old ones are freed. IOW not doing a
> full close/open.
>
> E.g. nfp_net_set_ring_size().

This has been suggested before and looks great when you know you've got 
the resources for dual allocations.  In our case this code is also used 
inside our device where memory is tight: we are much more likely to have 
allocation issues if we try to allocate everything without first 
releasing what we already have.

I agree there is room for evolution, and we have patches coming that 
change some of how we allocate our memory, but we're not quite ready to 
rewrite what we have, or to split the two driver cases yet.

sln

