Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA4410C340
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 05:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfK1EhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 23:37:16 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41953 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1EhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 23:37:16 -0500
Received: by mail-io1-f68.google.com with SMTP id z26so23946432iot.8;
        Wed, 27 Nov 2019 20:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MhBD8FldgWDB7ubM1+bg4CA0wEesKVjK+ARC6kecBbM=;
        b=uePEqEdxv92L3sIfzubpAqH7fYlICZEKjnG6tZwRSrldFfjiGBQcEP/ri/HIj8H2fD
         B50DaQfhflLV0weORepX0LHHtXBMeMSPBQrfmXhJwKex5Ki6vQ6upj3vcCFxAY0gGDe0
         Sm3tnj0umtnVfSSccqACwedQJmC0rA+AJhVkmMTv740V2WP+LhPmAjyVHlkGrazMwqJ2
         JCEfvVftCivGHsZwDYJk3P11ARg22fMfa0K1oBsUaWia6+5HCC4HQtWaxHY9eCaHRwiv
         4cRX9J9HN68cPwVRXC71M0drLVEgYH6IM8F7+oZNWq4iDbYW5SyGauEvHCEPts/b2kQq
         NjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MhBD8FldgWDB7ubM1+bg4CA0wEesKVjK+ARC6kecBbM=;
        b=S7cX6jfGQv1aM7vRiPefcKzZDANPeBWgjGso4mTMWG2QxkmQJ5GGn56Ti+yz4+erc3
         4gl2JgBJaLFT1yB1kQEsgTP5bkBmxaVP+zk744F/Nes+SijpkoDgwXrvG71u3Cm0hlN5
         BM+jYF/a+9AWK9GO51ntbbbM861kVoOdFpO2hFkmZhZ4RVbpIdXQ5J/KMb8m6lcs58N/
         sI1eJMdurdRGFYXbfQqfob/iXOMyZYfN++XbTOw4iEWGCfEcGNK2XJ8BFd3yFIKNBc8F
         U9ybvELLPyWSEj7lp3BVYnoDTYGSXP6G5a7c6cjQgASxSCj1HR9f9kltVmccH+hj6Fki
         ImKQ==
X-Gm-Message-State: APjAAAVa1kYaEwhrkuv/EG+HVT0oBui/nFOc7ZibFdhnDwPvXEXlCRrB
        tb9Cl959MAglWQXFqoF58WPwz1u4
X-Google-Smtp-Source: APXvYqw6noxU06VeRXfTZCraNQ+koeXy+v6wrLYFU1b+DMhT3fEUFgPoBbCxtrD59jAWiiI2ylpLtw==
X-Received: by 2002:a6b:d119:: with SMTP id l25mr38250926iob.44.1574915835625;
        Wed, 27 Nov 2019 20:37:15 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l9sm4266093iob.37.2019.11.27.20.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 20:37:15 -0800 (PST)
Date:   Wed, 27 Nov 2019 20:37:07 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5ddf4ef366a69_3c082aca725cc5bcbb@john-XPS-13-9370.notmuch>
In-Reply-To: <20191127225759.39923-1-sdf@google.com>
References: <20191127225759.39923-1-sdf@google.com>
Subject: RE: [PATCH bpf] bpf: force .BTF section start to zero when dumping
 from vmlinux
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> While trying to figure out why fentry_fexit selftest doesn't pass for me
> (old pahole, broken BTF), I found out that my latest patch can break vmlinux
> .BTF generation. objcopy preserves section start when doing --only-section,
> so there is a chance (depending on where pahole inserts .BTF section) to
> have leading empty zeroes. Let's explicitly force section offset to zero.
> 
> Before:
> $ objcopy --set-section-flags .BTF=alloc -O binary \
> 	--only-section=.BTF vmlinux .btf.vmlinux.bin
> $ xxd .btf.vmlinux.bin | head -n1
> 00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
> 
> After:
> $ objcopy --change-section-address .BTF=0 \
> 	--set-section-flags .BTF=alloc -O binary \
> 	--only-section=.BTF vmlinux .btf.vmlinux.bin
> $ xxd .btf.vmlinux.bin | head -n1
> 00000000: 9feb 0100 1800 0000 0000 0000 80e1 1c00  ................
>           ^BTF magic
> 
> As part of this change, I'm also dropping '2>/dev/null' from objcopy
> invocation to be able to catch possible other issues (objcopy doesn't
> produce any warnings for me anymore, it did before with --dump-section).

Agree dropping /dev/null seems like a good choice. Otherwise seems reasonable
to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>
