Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64681AD4BD
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 05:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgDQDMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 23:12:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729477AbgDQDMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 23:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587093151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kod4sBVNZl13j111ZtiqdMeSXjTm/Tfeat7xy/R1z0=;
        b=UmkpulOEhPVyx1Nhm0K6LXPQr5R/7TvL960h1wlck/vdXIXgiokkHbrNSs5mvkpk+1LUhp
        9zSQKUjShkBE/FmNn/mg5pEHsdgoaa7+1O0qamfIA2KhxhE4v7q4UJcPPy3Iw0mG1IraWa
        tjcvTRemqXlhdCAnQiPHxf3Yd4UR2m4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-IdiGn_JcMJi4EAOTBKuGeg-1; Thu, 16 Apr 2020 23:12:26 -0400
X-MC-Unique: IdiGn_JcMJi4EAOTBKuGeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D22E8017F3;
        Fri, 17 Apr 2020 03:12:24 +0000 (UTC)
Received: from [10.72.13.254] (ovpn-13-254.pek2.redhat.com [10.72.13.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F061027BD7;
        Fri, 17 Apr 2020 03:12:15 +0000 (UTC)
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
References: <20200415024356.23751-1-jasowang@redhat.com>
 <20200416185426-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
Date:   Fri, 17 Apr 2020 11:12:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200416185426-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/17 =E4=B8=8A=E5=8D=886:55, Michael S. Tsirkin wrote:
> On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
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
>> Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>  (s390)
>> Acked-by: Michael Ellerman<mpe@ellerman.id.au>  (powerpc)
>> Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
>> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Michael Ellerman<mpe@ellerman.id.au>
>> Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
>> Cc: Vasily Gorbik<gor@linux.ibm.com>
>> Cc: Christian Borntraeger<borntraeger@de.ibm.com>
>> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> I rebased this on top of OABI fix since that
> seems more orgent to fix.
> Pushed to my vhost branch pls take a look and
> if possible test.
> Thanks!


I test this patch by generating the defconfigs that wants vhost_net or=20
vhost_vsock. All looks fine.

But having CONFIG_VHOST_DPN=3Dy may end up with the similar situation tha=
t=20
this patch want to address.

Maybe we can let CONFIG_VHOST depends on !ARM || AEABI then add another=20
menuconfig for VHOST_RING and do something similar?

Thanks


