Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C792059F6
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733211AbgFWRul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:50:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbgFWRuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592934638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cfv0Cil1khcQKnkjQhrpBgHiVbTl1eQxEluk1MKgoQ=;
        b=JeDUeqh282ACm+lfkpAaSbWkWcXvNrajloeoYQRVdSo0BsBmciZrbdRT/0MYg4wOtKpoi/
        jH8/WHcpiEyO+dwYX/QRFjlIr21ArCT23xjiQiAo/KfzPoZA1yP4RvvQnFliWctixuViFq
        ZxCSYXywVQC/dvcFGUZ5oToZF+2ER5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-bWRygtN2NeepGnJKbcCMYw-1; Tue, 23 Jun 2020 13:50:34 -0400
X-MC-Unique: bWRygtN2NeepGnJKbcCMYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498DA800597;
        Tue, 23 Jun 2020 17:50:33 +0000 (UTC)
Received: from ovpn-114-234.ams2.redhat.com (ovpn-114-234.ams2.redhat.com [10.36.114.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F8735C1D4;
        Tue, 23 Jun 2020 17:50:31 +0000 (UTC)
Message-ID: <7e7ee41bc1c4c714eae7df10dddb5eb20ed51912.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 1/2] indirect_call_wrapper: extend indirect
 wrapper to support up to 4 calls
From:   Paolo Abeni <pabeni@redhat.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 23 Jun 2020 19:50:30 +0200
In-Reply-To: <20200623164232.175846-1-brianvv@google.com>
References: <20200623164232.175846-1-brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-23 at 09:42 -0700, Brian Vazquez wrote:
> There are many places where 2 annotations are not enough. This patch
> adds INDIRECT_CALL_3 and INDIRECT_CALL_4 to cover such cases.
> 
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  include/linux/indirect_call_wrapper.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
> index 00d7e8e919c6..54c02c84906a 100644
> --- a/include/linux/indirect_call_wrapper.h
> +++ b/include/linux/indirect_call_wrapper.h
> @@ -23,6 +23,16 @@
>  		likely(f == f2) ? f2(__VA_ARGS__) :			\
>  				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
>  	})
> +#define INDIRECT_CALL_3(f, f3, f2, f1, ...)					\
> +	({									\
> +		likely(f == f3) ? f3(__VA_ARGS__) :				\
> +				  INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__);	\
> +	})
> +#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)					\
> +	({									\
> +		likely(f == f4) ? f4(__VA_ARGS__) :				\
> +				  INDIRECT_CALL_3(f, f3, f2, f1, __VA_ARGS__);	\
> +	})
>  
>  #define INDIRECT_CALLABLE_DECLARE(f)	f
>  #define INDIRECT_CALLABLE_SCOPE
> @@ -30,6 +40,8 @@
>  #else
>  #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
>  #define INDIRECT_CALL_2(f, f2, f1, ...) f(__VA_ARGS__)
> +#define INDIRECT_CALL_3(f, f3, f2, f1, ...) f(__VA_ARGS__)
> +#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
>  #define INDIRECT_CALLABLE_DECLARE(f)
>  #define INDIRECT_CALLABLE_SCOPE		static
>  #endif

Acked-by: Paolo Abeni <pabeni@redhat.com>

