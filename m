Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0213A332F0C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCITd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhCITdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:33:44 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B62C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 11:33:43 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id j22so8142080otp.2
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 11:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=45VapyaJxkraY0/xl0liYLNmq4QHcW7DfEuE2Ey7MBc=;
        b=auXOg8S9ei5rWbwUXiSEb2k9IftLplmxFk6SyQu1DmcUGV+5Vwpm1zTArFoRlZoRGW
         MD1B6eRnBzDdGtvYov1HCwAwrNK6VZqXvTKwTxuUVdYGsK7aGWeMp7qgEAZ0b+4mBsBL
         g7GiS56ZdmSbowcv+M8csQaWTcNd//3scLSsF98QuQiYzh6y6V0elEnIvy3/4Ws5GsZf
         lMS7q3hQSbThbfn+I6YQ9CsisINNWUOze86l4diV5dZqyOtBVDZQCXKP89Z5OPt28RwZ
         8s9bg2YIlpD5OIzSwzUD4YVSjekAkKRxULwOClwI979DYQ7Hksv3NzuekK0BXUGs6LJz
         qcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=45VapyaJxkraY0/xl0liYLNmq4QHcW7DfEuE2Ey7MBc=;
        b=sMsFobqSsF2aIwOZ/uBs30UqVz/exbGONEEv+hQBM0niI92rlafUZsaS5vnowD0JwN
         L9WUeiU5khXP24fVLRNnnPLEjG4FxisX7SHItcb/wUkHD3ga28vtgoM60QmIBlwqaBJ2
         gjvNvONdqvRrWalCHnNIc+RXL/CkybAqFCAm4dHsH0PmS8yaRt4zQQfpVgwiz6zxnHTN
         9h8xvX3T0p/JDrCanIXdVegyk8wsRbxBb1rr+p8vefij2BbGrQ9b+1PVUjOimuLNWm5M
         T88JH2my8pz0pYvXWTkj+zfsTqV2blTZGLsbREdq+XV7ZBQ8oIFwHmi+KrWJGP/1PO6m
         wCxQ==
X-Gm-Message-State: AOAM532F582RXoqGRvDhd7z6oZwOpVsY8B6KZIN311qaa921GKvfc/qf
        tjB8jqiJvgN965LShOB7pASx3SJ3MrY=
X-Google-Smtp-Source: ABdhPJzXENofFWUTwZffhH9WGKEIYmVIoHmyuOZcyMfwYiVbeSp3IcADz1hnWtUwQzFXvl3tEX4IxA==
X-Received: by 2002:a05:6830:1304:: with SMTP id p4mr25074535otq.185.1615318423232;
        Tue, 09 Mar 2021 11:33:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id w7sm1888670ote.52.2021.03.09.11.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 11:33:42 -0800 (PST)
Subject: Re: [PATCH net] ipv6: fix suspecious RCU usage warning
To:     Wei Wang <weiwan@google.com>, Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20210308192113.2721435-1-weiwan@google.com>
 <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
 <YEcukkO7bsKYVqEZ@shredder.lan>
 <CAEA6p_C8TRWsMCvs2x7nW9TYUwEyBrL46Li3oB-HjNwUDjNcwQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f4ffcaf3-adfe-3623-2779-fc9ce1a363ce@gmail.com>
Date:   Tue, 9 Mar 2021 12:33:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAEA6p_C8TRWsMCvs2x7nW9TYUwEyBrL46Li3oB-HjNwUDjNcwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 10:32 AM, Wei Wang wrote:
> Thanks David and Ido.
> To clarify, David, you suggest we add a separate function instead of
> adding an extra parameter, right?

for this case I think it is the better way to go.
