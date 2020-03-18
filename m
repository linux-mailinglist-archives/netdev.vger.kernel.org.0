Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28DF189708
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgCRI1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:27:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33659 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbgCRI1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584520066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VH0+XlPo10NyA/xz91Ej5gjsjWF5TbKzK+mngsaI8Lo=;
        b=OQyJWYtzDd6/SfjlVR5AekUXhPqKnAUYbuurb/fpICxE/LUgZfVeLvIpcgnkiMWgoel+7A
        6iWgGpjE12ES/Lq99k+IRN6JBQGzMilKEvM/iVA5euWcL+9o3zw1nSM2ylEt/v2mi+oTx/
        iiYFx3y8CEnAL4osX/iO8vSUKTrYZIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-yA7fyRPiO0KsCqIveqAp5A-1; Wed, 18 Mar 2020 04:27:43 -0400
X-MC-Unique: yA7fyRPiO0KsCqIveqAp5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D72D4800D4E;
        Wed, 18 Mar 2020 08:27:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D081819C70;
        Wed, 18 Mar 2020 08:27:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200317194140.6031-5-longman@redhat.com>
References: <20200317194140.6031-5-longman@redhat.com> <20200317194140.6031-1-longman@redhat.com>
To:     Waiman Long <longman@redhat.com>
Cc:     dhowells@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
Subject: Re: [PATCH v4 4/4] KEYS: Avoid false positive ENOMEM error on key read
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2832138.1584520054.1@warthog.procyon.org.uk>
Date:   Wed, 18 Mar 2020 08:27:34 +0000
Message-ID: <2832139.1584520054@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Waiman Long <longman@redhat.com> wrote:

> +static inline void __kvzfree(const void *addr, size_t len)
> +{
> +	if (addr) {
> +		memset((void *)addr, 0, len);
> +		kvfree(addr);
> +	}
> +}

I wonder if that would be better as "kvfree(memset(...))" as memset() will
return the address parameter.  If memset is not inline, it avoids the need for
the compiler to save the parameter.

David

