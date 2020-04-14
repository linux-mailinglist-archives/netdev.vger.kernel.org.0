Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FAA1A77A0
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437786AbgDNJsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:48:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437776AbgDNJsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586857701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RCUnMVTMhiXmQTIRtH4ig9vejIyMaafXsJBXVyt/T0o=;
        b=Qx9SLKZnYhNTbLa8p/DYIAU0u2He3JEZV5OKgGMkD4j2ar8VvcMvI9spYac/1V3on30r2I
        gbJce48bO5HPmbEmghmwYgdkOH95MFmGVN4ZtiTnORz2dRt/vYrruVIsTRvK9PJofjgjuB
        2vmruUNOZBfI96c2As4BSe9rWipu3HM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-qE1gTkkzPsijc6xmZp2iOg-1; Tue, 14 Apr 2020 05:48:17 -0400
X-MC-Unique: qE1gTkkzPsijc6xmZp2iOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF2DE800D53;
        Tue, 14 Apr 2020 09:48:13 +0000 (UTC)
Received: from [10.72.13.119] (ovpn-13-119.pek2.redhat.com [10.72.13.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7602F1001920;
        Tue, 14 Apr 2020 09:48:05 +0000 (UTC)
Subject: Re: [PATCH] vhost: do not enable VHOST_MENU by default
To:     Christian Borntraeger <borntraeger@de.ibm.com>, mst@redhat.com
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200414024438.19103-1-jasowang@redhat.com>
 <375181ee-08ec-77a6-2dfc-f3c9c26705a1@de.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <802e6da9-4827-a9a4-b409-f08a5de4e750@redhat.com>
Date:   Tue, 14 Apr 2020 17:48:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <375181ee-08ec-77a6-2dfc-f3c9c26705a1@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/14 =E4=B8=8B=E5=8D=883:26, Christian Borntraeger wrote:
> On 14.04.20 04:44, Jason Wang wrote:
>> We try to keep the defconfig untouched after decoupling CONFIG_VHOST
>> out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
>> ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
>> default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
>> without the caring of CONFIG_VHOST.
>>
>> But this will leave a "CONFIG_VHOST_MENU=3Dy" in all defconfigs and ev=
en
>> for the ones that doesn't want vhost. So it actually shifts the
>> burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
>> not set". So this patch tries to enable CONFIG_VHOST explicitly in
>> defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
>>
>> Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
>> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Michael Ellerman<mpe@ellerman.id.au>
>> Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
>> Cc: Vasily Gorbik<gor@linux.ibm.com>
>> Cc: Christian Borntraeger<borntraeger@de.ibm.com>
> Fine with me.
> s390 part
>
> Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>
>
>   That was my first approach to get things fixed before I reported
> this to you.


Exactly.

Thanks

>

