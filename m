Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230C5344E21
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCVSKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCVSJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:09:56 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0543EC061574;
        Mon, 22 Mar 2021 11:09:55 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id t16so9102081qvr.12;
        Mon, 22 Mar 2021 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EtfHwr298OA3Z6gH92QCGkPJx1rZ0iaSYLbbS688xmU=;
        b=CzSq0IpfCHbjACIIUn5EHsx803//Z1Bf9E/e/eQTHSLd5aExRoF6QM6GGwzRfeaPyl
         xPSn15+MEoaC4oXb5SGbSend+RCIxEJ/xZXDUt1p/M4G1ZYpfraBPhAgVcOJtau2A70v
         Uco3esP/L64APb9F72bBMBVa/7FJess+D1DRKaT2/oVF7L2XBDvhnje/dzzJhky6qMXT
         h6S18SR/LRiKVeQiC4RSTg8zGsEUHTiTzGU9OBcaFR6Pkwd25LPpbqifv34F5eoy9hNX
         NPkQ+AHjwEbE+LOowbGi9z6mcnbHAFzoQEa3d+1m62pjoIwabnFJaMzd3VLIc0/4HYZT
         dKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EtfHwr298OA3Z6gH92QCGkPJx1rZ0iaSYLbbS688xmU=;
        b=db4YCHzfLjZywoJIEcVycR914ldQ1q92bkKRzMPGf1m249ELTFbnzQtWeXllYmxqpz
         Msg2I+CDwRq4d21QgegdD6nZBSlmVCSsJ74ZUKoWVuv86wSVZeN/ADfw0PlJNbeCmQg+
         9p71NamnMQps9jHX73fBsI87gW7CpJzuAPPWX4Vec0IurC53N9eEBsImz4NJX8WOKNjv
         ZZ/Y0LR75XzpiQdeV44FftIQZLVUs2nAS6f941bqE/ErlSnOFi47Z2WUp0Gs6KpkOiWc
         xUd3y5fAFZf7jLWBOV/dPy/xBQD1geDTenkxTG53Gi1K746otpPlCt/0XEbrlu/EbFPO
         kS4A==
X-Gm-Message-State: AOAM530we7/IfjTGx6vIZQihy0J1LM0wOXrxoT1QgRE7mOQZPKzJq9Me
        n2dgO59MDGXnZOB/8QM1fAc=
X-Google-Smtp-Source: ABdhPJxKv9VoSKf42stNFx6DeVOxuN76tIcaTtJ6CnG2sOwdTrzRscbdtu879PZDscBNH7jtHzrfCA==
X-Received: by 2002:ad4:4b2c:: with SMTP id s12mr993364qvw.19.1616436595061;
        Mon, 22 Mar 2021 11:09:55 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:19d0:fe89:4076:65c3:b762])
        by smtp.gmail.com with ESMTPSA id y6sm1348966qkd.106.2021.03.22.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:09:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 9F9A8C007F; Mon, 22 Mar 2021 15:09:51 -0300 (-03)
Date:   Mon, 22 Mar 2021 15:09:51 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <YFjdb7DveNOolSTr@horizon.localdomain>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303161147.GA17082@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Wed, Mar 03, 2021 at 02:59:53PM +0200, Oz Shlomo wrote:
> > Currently the flow table offload replace, destroy and stats work items are
> > executed on a single workqueue. As such, DESTROY and STATS commands may
> > be backloged after a burst of REPLACE work items. This scenario can bloat
> > up memory and may cause active connections to age.
> > 
> > Instatiate add, del and stats workqueues to avoid backlogs of non-dependent
> > actions. Provide sysfs control over the workqueue attributes, allowing
> > userspace applications to control the workqueue cpumask.
> 
> Probably it would be good to place REPLACE and DESTROY in one single
> queue so workqueues don't race? In case connections are quickly
> created and destroyed, we might get an out of order execution, instead
> of:
> 
>   REPLACE -> DESTROY -> REPLACE
> 
> events could be reordered to:
> 
>   REPLACE -> REPLACE -> DESTROY
> 
> So would it work for you if REPLACE and DESTROY go into one single
> workqueue and stats go into another?
> 
> Or probably make the cookie unique is sufficient? The cookie refers to
> the memory address but memory can be recycled very quickly. If the
> cookie helps to catch the reorder scenario, then the conntrack id
> could be used instead of the memory address as cookie.

Something like this, if I got the idea right, would be even better. If
the entry actually expired before it had a chance of being offloaded,
there is no point in offloading it to then just remove it.

  Marcelo
