Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327AF3409AF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhCRQJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhCRQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:08:51 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE5DC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:08:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id g1so1535415plg.7
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dyaQPHheaZfo9zJGBo9JvWCA7OYoru9MzsGC+/dddsE=;
        b=QTcA35ttPaO523oybKZCD5icJFxK0byf2/nH6hhjPPApcQHag3GSTp9MesqgiG9F8y
         qWvylp28TYco6cGNn5dmsbdhPsuXn25VfIFJETJ1hgglhuLHTpFl3M4kcLLI67mWXoR1
         i/TGsYGN40S+ztLwfHZA8LukjxyVmg1J7FIVLpSxQ7mJJhGfmCZkojoD4P+9e+gdiUAv
         1+yGuQC3Z1CzlsIRIwPxQ40Sy20Ayl57DS8RUB0U4b2ksrTzxaSEMiW/GvUCO5Qhw5kE
         MRc/NXvvmLy83OkU3ErcHFPZQSIwabHOgFv8g1qxzNsosADDakclarEmeJotXN+yOI60
         W8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dyaQPHheaZfo9zJGBo9JvWCA7OYoru9MzsGC+/dddsE=;
        b=lTiuLs9+ZI951rtIHg4zUNUZ0FHOYbZMdhunPW5eCqaTgyED9+ltBUbPy3bee1vjlL
         AC8jQf42cY44S0hBVafiXrLUks0zL1GCy737AXoPiucxdFIAkU+Qc4fFTuFL40tokb73
         +ZQxhxKJGWM/Npgl7FuvmV1084dJoa/b7n0Erwxirh2SOTIQL4v4470bWluYOHvgTyd1
         +IxoFbHWbkXgkMpYsVZsTn8UIxuppxbjn4BMBcnn8pcMH6Xe/LxN9xbpQTkJ1usCtfiE
         1ML+D9bY1XlYzN6PmC4LodHxswnW/I5FwbIBTlRa/zNtMfzhGqKGwxPSZLpP0rYOpwnZ
         9VUw==
X-Gm-Message-State: AOAM532ABj7mqg/uKhBv+CnmmA0ZTKh5rNMOKTTzFitBcrpJQMbwpXex
        VD0Q/26tm2NkshT8MnfJbTJhBPuBn+w=
X-Google-Smtp-Source: ABdhPJzNOgC2VoYDhfQ3DC9QjLIEse9VNiLW6cGxr+rpKagX2bo5mzBdAtOjIuz3yadga515cqZU2A==
X-Received: by 2002:a17:90a:5898:: with SMTP id j24mr5136714pji.103.1616083729970;
        Thu, 18 Mar 2021 09:08:49 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 205sm2808379pfc.201.2021.03.18.09.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:08:49 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/8] net: dsa: mv88e6xxx: Avoid useless
 attempts to fast-age LAGs
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-3-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ccb98da-1f2a-03e4-d3dc-22d9eac0edef@gmail.com>
Date:   Thu, 18 Mar 2021 09:08:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-3-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> When a port is a part of a LAG, the ATU will create dynamic entries
> belonging to the LAG ID when learning is enabled. So trying to
> fast-age those out using the constituent port will have no
> effect. Unfortunately the hardware does not support move operations on
> LAGs so there is no obvious way to transform the request to target the
> LAG instead.
> 
> Instead we document this known limitation and at least avoid wasting
> any time on it.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
