Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2997E162C77
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBRRSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:18:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726671AbgBRRSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582046295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ek37kVTDy+eubHSmBaHlU9802HiWJpZwSmyiNbGJoro=;
        b=M5rFuEHug/ZtNlxV0hPVRe9RcJpZ9v57I1lCLNI7XP0rHcl5vBKMovji8EYkwDo7w8JJNd
        SCLUW3jX/iInQbhS6552040hwLhJMrnDSOw5yKFL89y0QPmEvcoylKbgPcrm8t4qagSbyb
        CzLpsTQMl1WxD32zFrCV52RiGjP0KGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-uC0VfL6AP3Ci3cM_MFvf2Q-1; Tue, 18 Feb 2020 12:18:10 -0500
X-MC-Unique: uC0VfL6AP3Ci3cM_MFvf2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CD648010FF;
        Tue, 18 Feb 2020 17:18:06 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D179990F70;
        Tue, 18 Feb 2020 17:17:53 +0000 (UTC)
Date:   Tue, 18 Feb 2020 18:17:51 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, lorenzo@kernel.org, toke@redhat.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: page_pool: API cleanup and comments
Message-ID: <20200218181751.1d7139d2@carbon>
In-Reply-To: <20200218141031.377860-1-ilias.apalodimas@linaro.org>
References: <20200218141031.377860-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 16:10:31 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Functions starting with __ usually indicate those which are exported,
> but should not be called directly. Update some of those declared in the
> API and make it more readable.
>=20
> page_pool_unmap_page() and page_pool_release_page() were doing
> exactly the same thing calling __page_pool_clean_page().  Let's
> rename __page_pool_clean_page() to page_pool_release_page() and
> export it in order to show up on perf logs and get rid of
> page_pool_unmap_page().
>=20
> Finally rename __page_pool_put_page() to page_pool_put_page() since we
> can now directly call it from drivers and rename the existing
> page_pool_put_page() to page_pool_put_full_page() since they do the same
> thing but the latter is trying to sync the full DMA area.
>=20
> This patch also updates netsec, mvneta and stmmac drivers which use
> those functions.
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

LGTM - on a quick review (not compile tested...).

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
> Changes since
> v1:
> - Fixed netsec driver compilation error
> v2:
> - Improved comment description of page_pool_put_page()
> v3:
> - Properly define page_pool_release_page() in the header file
>   within an ifdef since xdp.c uses it even if CONFIG_PAGE_POOL is not sel=
ected
> - rename __page_pool_clean_page -> page_pool_release_page and get rid of
> another redundant helper

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

