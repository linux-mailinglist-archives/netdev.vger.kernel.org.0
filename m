Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6582F5D444
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGBQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:31:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46175 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfGBQbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:31:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so8498039pfy.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=TnwPkG+iTbaNgT4SwBC0FtajjMVheShHJgOEezj21l4=;
        b=On4AOmeCHVKUQR3RFwyiJu3Dt6U0R+7widM/Lzt2YG5CErejQg25Z8v0ikzXO+UekZ
         9RHoQ4x0s/6xOFZ3QYEPHti78aHl3VRmBHCW4fRbtZz5OTPpShq/6hmnOd2HxLrkZ7Ns
         D8/OELrjpbDZ21sZSAtKx5XB4GCt1jQFKllfc1eJ0uj+kBoTseOy9mTdEA+0YvVqpKij
         EQi9IBlom8WwHfKECGAA8fFvoU+YF8enq/xOyTsVWbIdCFjTR9S3LX+3EV8IT6oeDeI7
         q+bGJmIZQLcOHCiGdKynrX9Sczud6tATrzmuHsXqI706hrAECwQBrTgmWvzRM0qyCu9w
         Cwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=TnwPkG+iTbaNgT4SwBC0FtajjMVheShHJgOEezj21l4=;
        b=MmbbiSDxUFyTtYcUKK8NoqViq5tOmxByYnW5Ubz8pBFQV5frZCKE9W+xQlxDLNWbvk
         IiIFyjMUSgWevIY7QIlJWNfiZTJvWs67bZniL77II/gBwAOg4IXv9DLcRYp2wk6zF6s1
         WYV+vVugLIMg9xHOAEsIaRqjmh4/LQoSrCkm9Glu1CWUcIzmdGDJfAiVb+vvSxeIasro
         SEcuaTy/kI2SuJ2M80TTmiAV9Pe+f9lC5LlXqeWLyjiY42yDN4Bw0/Fe+n8otwuSXpN0
         nx1Zn0MMhrzkZ6uZOymYRWUzaOSOqGVdTyDyB6YtggxP/KoF5Yd+MXbM1aZNbUS9ZubZ
         p2Pg==
X-Gm-Message-State: APjAAAUcSwghlTKSRVvtXrRfV6PrxS+N/eK2j9F14CVId7CP4xv/zu2K
        JtPvW77ypO0If4VaCw6HV1pQfgkVq9w=
X-Google-Smtp-Source: APXvYqxlVD3BcyKqW4M82y58fdUg5ZcrZW3FMCuNXgVgT2Hn9wRVGt1d3YbHFcMv3IThnTFqEnwPkg==
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr6569925pjr.50.1562085062197;
        Tue, 02 Jul 2019 09:31:02 -0700 (PDT)
Received: from [172.20.54.151] ([2620:10d:c090:200::ef17])
        by smtp.gmail.com with ESMTPSA id x14sm17210214pfq.158.2019.07.02.09.31.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:31:01 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Maxim Mikityanskiy" <maximmi@mellanox.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, jakub.kicinski@netronome.com,
        jeffrey.t.kirsher@intel.com, kernel-team@fb.com
Subject: Re: [PATCH 2/3 bpf-next] i40e: Support zero-copy XDP_TX on the RX
 path for AF_XDP sockets.
Date:   Tue, 02 Jul 2019 09:31:00 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <042416A5-BA37-4F07-BD59-7FA13813B8A7@gmail.com>
In-Reply-To: <f9c7b86c-91a6-9585-d1f1-f6f325794038@mellanox.com>
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
 <20190628221555.3009654-3-jonathan.lemon@gmail.com>
 <f9c7b86c-91a6-9585-d1f1-f6f325794038@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Jul 2019, at 0:07, Maxim Mikityanskiy wrote:

> On 2019-06-29 01:15, Jonathan Lemon wrote:
>> +	xdpf = convert_to_xdp_frame_keep_zc(xdp);
>> +	if (unlikely(!xdpf))
>> +		return I40E_XDP_CONSUMED;
>> +	xdpf->handle = xdp->handle;
>
> Shouldn't this line belong to convert_to_xdp_frame_keep_zc (and the
> previous patch)? It looks like it's code common for all drivers, and
> also patch 1 adds the handle field, but doesn't use it, which looks weird.

Good point.  I'll move it into the function.
-- 
Jonathan
