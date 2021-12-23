Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EB47E56B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhLWPYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhLWPYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:24:12 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E9C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 07:24:12 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id y16so7524375ioc.8
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 07:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=4zVajV20KPdu35E00sbLWdAM4v9gyfqdQSaA3gZjTR4=;
        b=TwFLoxLFOztBwNFjsxZWAfCmiUj1qLcH59zeFdKKNAMYZsbepHXZm9TsMibwJg4beO
         9snaDSBShu+v9uYTtopaTAdos6yOG/+TYWKYu30pI+Lv9pX3BCNJ9w9lEp5P/OY5q4G9
         Yoz75RrkSRPQX8NVLHvfxekF9y2dPgciNMzdJJvFxDNzmcx5oaUfaabY4DBbHHlxr8hk
         WizyYO503AZDSzu5BH+YRh6BM8LcJquWJdqcUbWLDB+UINWgm4R+sN9yIj/ZBlWm2kQZ
         4eDTk9sEf6xE8GCKsy90Az5L72zxhoCE601XfMBvKajAI5P4xnQMHXHNHFtU0k+53QK9
         PBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=4zVajV20KPdu35E00sbLWdAM4v9gyfqdQSaA3gZjTR4=;
        b=C+w/gL+HyvryKQgHPCw/OjG16mHa2zGHpAWmjM7VDMYDqr93gzAuwcMe8eD6H4ItMN
         VP7Kk3QFYXiiZtdX/jYbl1ovm/68EzQhoHxZBagRNV6qysqac9CEuBwj/UfvZThSVHSP
         SbOQyrpcy12NkvlHCU/FPvie9k9nhVT7nD/1je/fJCWTvOyeY2oX/YMoiswxXYXncwO8
         m2pLVWCYiyHspF/qNfSCNyesQtsD4puvetuqtw0btuFHYzgmTGRMLYwsk7V2I5PCJlfw
         2dzbl00aUcHGWZ8nlMwA1VseXXBBqQKy0/fH9//2ntjkphd3GXhNBnpFExBvwvD2y8Mg
         UQEA==
X-Gm-Message-State: AOAM531tFZjBd3ATre1p7bl9d152xb7IPgf7hzZhE50kNPwDFmfsFBAz
        Ud7X5Ij9L2/KW+PHJ3UlfbRNT/GOjNK6eUo=
X-Google-Smtp-Source: ABdhPJz3spx+ZRSfVyyYfskEe9qB3cMmiKbQXp22JTrUVK6hxwOrWxKfXuCSXD5Qk3A3rZGlMq+pqQ==
X-Received: by 2002:a02:cf39:: with SMTP id s25mr1401366jar.17.1640273051175;
        Thu, 23 Dec 2021 07:24:11 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id x5sm3558270iov.50.2021.12.23.07.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:24:10 -0800 (PST)
Message-ID: <18a0da3ad5d5a2aba9b7c35907b227e6ad5620f3.camel@egauge.net>
Subject: Re: [PATCH v2 00/50] wilc1000: rework tx path to use sk_buffs
 throughout
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Dec 2021 08:23:59 -0700
In-Reply-To: <adce9591-0cf2-f771-25b9-2eebea05f1bc@microchip.com>
References: <20211223011358.4031459-1-davidm@egauge.net>
         <adce9591-0cf2-f771-25b9-2eebea05f1bc@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-23 at 06:16 +0000, Ajay.Kathat@microchip.com wrote:
> On 23/12/21 06:44, David Mosberger-Tang wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > OK, so I'm nervous about such a large patch series, but it took a lot
> > of work to break things down into atomic changes.  This should be it
> > for the transmit path as far as I'm concerned.
> 
> Thanks David for the efforts to break down the changes. I am still 
> reviewing and testing the previous series and found some inconsistent 
> results. I am not sure about the cause of the difference. For some 
> tests, the throughput is improved(~1Mbps) but for some CI tests, the 
> throughput is less compared(~1Mbps in same range) to the previous. 
> Though not observed much difference.

There shouldn't be any significant performance regressions.  From my
observations, +/-1Mbps in throughput is quite possible due to cache-
effects.

> Now the new patches are added to the same series so it is difficult to 
> review them in one go.

Ah, OK, sorry about that.  After the automated error reports, I waited
for a day or two and after not seeing any further feedback, I figured
it'd be fine to add to the series.

I take it that as long as a patch shows up in patchworks with a
state==Action required, I should assume the patch is being worked on
(or will be worked on).

> I have a request, incase there are new patches please include them in 
> separate series.

I'm not planning on adding more patches.

  --david


