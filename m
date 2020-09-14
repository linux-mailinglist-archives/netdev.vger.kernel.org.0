Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53258269137
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgINQOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:14:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbgINQM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600099975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMcjuPLsban/s/KhGcm7R6jbGaWdBO7FK18RrhrF4m4=;
        b=UnunqAY4EbEa+aaNV58/gBSPTDAZmoP+P+y136DkmHhYC2de6r9m7p0H61SPEh8m6MtL46
        kEl4o9AwFLI6dbdkZEmGfk7uaYlzaxCuaAa1br6fCZooQlf8kqn4qspKgj3fQpNG2T0936
        NWak+kb7fyX0bzL7Utjn+U+4zMflNn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-lmWKx1gVNNS1mWTiGcUWJw-1; Mon, 14 Sep 2020 12:12:52 -0400
X-MC-Unique: lmWKx1gVNNS1mWTiGcUWJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7981D425FD;
        Mon, 14 Sep 2020 16:12:49 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA4B7EEC9;
        Mon, 14 Sep 2020 16:12:35 +0000 (UTC)
Date:   Mon, 14 Sep 2020 18:12:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914181234.0f1df8ba@carbon>
In-Reply-To: <20200914140114.GG24441@willie-the-truck>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
        <20200914122042.GA24441@willie-the-truck>
        <20200914123504.GA124316@apalos.home>
        <20200914132350.GA126552@apalos.home>
        <20200914140114.GG24441@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 14 Sep 2020 15:01:15 +0100 Will Deacon <will@kernel.org> wrote:

> Hi Ilias,
> 
> On Mon, Sep 14, 2020 at 04:23:50PM +0300, Ilias Apalodimas wrote:
> > On Mon, Sep 14, 2020 at 03:35:04PM +0300, Ilias Apalodimas wrote:  
> > > On Mon, Sep 14, 2020 at 01:20:43PM +0100, Will Deacon wrote:  
> > > > On Mon, Sep 14, 2020 at 11:36:21AM +0300, Ilias Apalodimas wrote:  
> > > > > Running the eBPF test_verifier leads to random errors looking like this:  
> 
> [...]
> > >   
> > Any suggestion on any Fixes I should apply? The original code was 'correct' and
> > broke only when bounded loops and their self-tests were introduced.  
> 
> Ouch, that's pretty bad as it means nobody is regression testing BPF on
> arm64 with mainline. Damn.

Yes, it unfortunately seems that upstream is lacking BPF regression
testing for ARM64 :-(

This bug surfaced when Red Hat QA tested our kernel backports, on
different archs.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

