Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139F932F338
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 19:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCESww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 13:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCESwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 13:52:34 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94A4C061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 10:52:33 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id w7so2348829wmb.5
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VqSTb55wdEhMt8fqGSspUv9EKJhVRQuqlP8iiWWUERM=;
        b=vOBo/V9gy4ONZRYIWvqAk05g2RHmTk2MmOIbfJ2kvDLLgyLfWHmaJEnlW1Dofmjlwz
         F7vhhhmTeAGqQ1XqSFS4ulv5DXotM4dueo1Dev2TXQbV8yEMsr3vplDorX1AAeJs3Fo8
         TxD05Mo5UdJwYh8Sa/ivW3TcJSPC6Evw5RzIsG/+xpTy2hPqX6hYcXId2g0oNPXLBDyd
         rs/+mjncXVrh2rwPYxKmvBruDV3vi8tchkHE2Fbe6q7F0ZS4xB7yilZvR58zO9Shm/pK
         pw0RheXIjaX5mREj0dMyfoZDszdmyWbKsFtWS2s6RlFMdXF96rT5sYPR3aOfKL71JzKr
         NRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VqSTb55wdEhMt8fqGSspUv9EKJhVRQuqlP8iiWWUERM=;
        b=sHkRTBS2Fl9mg24plIHt+r9dvO5SN+6mUzSa1Ky63eMdt7ylLAOVSDWbN+Ym68MfcH
         +olHnUmIGeFuEV3QzZXZCSjQQ0vm6Z2HeExyh42yWaG88lMe0tuhvMhXpRhWWWVrFi/d
         qbgdNpdY8jGmBDwj1M0vKNoE4mm7d6bKpfNYSvAC1yF19e0eRhjwt4p3P45IrQT0BdIi
         SydugH+O42OSAa659zexjxPqguHpHMWI3BSvGhe7MQdW/ijyX/uN8pggEI7qfES8mNjO
         7tPyb6woEkPL1XldYBNByhgUqO99vCs6MAIci3U/KdoNH+hdcGDfVJ7WfffIHVcp6ugI
         KNYA==
X-Gm-Message-State: AOAM532AOcyV1FQcwBHtENUKFXhZvJrC6e6gpyZ2oWq/SowSFGmFjq/y
        sInyPKgpZcXa4FNhygmA4GrkjIW9T25gdOeypw8=
X-Google-Smtp-Source: ABdhPJzA7OsPrs8sp6ubN7znH8Wxlg1FurVAa9gj/z1tzrnCkqN1xhJGTN6gqyzULMwDkczirbt7FOOPP2tLjwqTw34=
X-Received: by 2002:a7b:c010:: with SMTP id c16mr10447069wmb.134.1614970352770;
 Fri, 05 Mar 2021 10:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20210305074456.88015-1-ljp@linux.ibm.com> <20210305184157.GA1411314@us.ibm.com>
In-Reply-To: <20210305184157.GA1411314@us.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 5 Mar 2021 12:52:22 -0600
Message-ID: <CAOhMmr6cbrnX_j3Hgwpbgt_Ou7UtkgJRToCTjuq5hTPPjrwnrw@mail.gmail.com>
Subject: Re: [RFC PATCH net] ibmvnic: complete dev->poll nicely during adapter reset
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dany Madden <drt@linux.ibm.com>, tlfalcon@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 12:44 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> Lijun Pan [ljp@linux.ibm.com] wrote:
> > The reset path will call ibmvnic_cleanup->ibmvnic_napi_disable
> > ->napi_disable(). This is supposed to stop the polling.
> > Commit 21ecba6c48f9 ("ibmvnic: Exit polling routine correctly
> > during adapter reset") reported that the during device reset,
> > polling routine never completed and napi_disable slept indefinitely.
> > In order to solve that problem, resetting bit was checked and
> > napi_complete_done was called before dev->poll::ibmvnic_poll exited.
> >
> > Checking for resetting bit in dev->poll is racy because resetting
> > bit may be false while being checked, but turns true immediately
> > afterwards.
>
> Yes, have been testing a fix for that.
> >
> > Hence we call napi_complete in ibmvnic_napi_disable, which avoids
> > the racing with resetting, and makes sure dev->poll and napi_disalbe
>
> napi_complete() will prevent a new call to ibmvnic_poll() but what if
> ibmvnic_poll() is already executing and attempting to access the scrqs
> while the reset path is freeing them?
>
napi_complete() and napi_disable() are called in the earlier stages of
reset path, i.e. before reset path actually calls the functions to
freeing scrqs.
So I don't think this is a issue here.
