Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD7316A36
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhBJPar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhBJPaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612970959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7GKWLGaz4Q366ycbGlbcuot0PlnFJKuyE+xeOCGXZic=;
        b=PRP+XFn8Hy/mX4UHjBOJ//HIg2ZiiISOs4ykMI4GwHcaMv/BkM+Gz6jwbchMl9Mkjj5Kkf
        Qu55JQgzyvOYHFxKImX0Iq54YPbMwCmHTJclN8BBx3DaGe7FLB8fTRhKfv45n5W8YKlAOT
        2Qsdet2Vjk1ReQqj4EVVCI1cXQKazak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-ywl4v_NbNXSjjaq_nuiyZg-1; Wed, 10 Feb 2021 10:29:17 -0500
X-MC-Unique: ywl4v_NbNXSjjaq_nuiyZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3723C73A0;
        Wed, 10 Feb 2021 15:29:15 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4EED60657;
        Wed, 10 Feb 2021 15:29:03 +0000 (UTC)
Date:   Wed, 10 Feb 2021 16:29:02 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, toke@redhat.com,
        Freysteinn.Alfredsson@kau.se, brouer@redhat.com
Subject: Re: [RFC bpf-next] bpf: devmap: move drop error path to devmpap for
 XDP_REDIRECT
Message-ID: <20210210162902.40f5252e@carbon>
In-Reply-To: <6266fb2549a06cb63d1593f9cee297a04b096433.1612966415.git.lorenzo@kernel.org>
References: <6266fb2549a06cb63d1593f9cee297a04b096433.1612966415.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Typo in subject line for devmap.

On Wed, 10 Feb 2021 15:18:14 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped frames.

I think you should start with explaining the "why change".

Copy pasted from design doc[1]:
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org#why-change

Why change: We want to change the current drop semantics, because it
will allow us to implement better queue overflow handling. This is
working towards the larger goal of a XDP TX queue-hook

> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
> 
> This is a preliminary patch to introduce a XDP_TX queue hook used to
> managed pending frames that has not been transmitted by the hw.
> More details about the new ndo_xdp_xmit design can be found here [0].
> 
> [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

