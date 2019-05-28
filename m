Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C02C6BF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfE1MjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:39:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41211 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfE1MjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:39:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id q17so6567881pfq.8;
        Tue, 28 May 2019 05:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rdsT8wChIEQo34ZPuzpJxdwcakwW6MiV0N2Abgg/21M=;
        b=jfk71X0jT4KQozFUVRleMel/vSn6HVF9v9CIfBEUYT0d7j1hfRB7NGAQfdYZoly9L4
         YUfXmt9SJK8b9RP2F+lnG4/5pfAE8gr4WNpmGp0MOXPgNw7ys4+3YQ/sXyG3wc+vreXi
         D2WWK2q9zVKRwnqEaLb43DcfhZqDk81WfXA/JIXAMn6qVrpnuc7hsWrM3HEuJqDSdMDB
         OMh46XHyZjlQDCkj0xQ/kFE7/SysXKMldh8z8yL47Jmklx2+HjVimfq5hdGwUJS9Qcwb
         5ThDXGhZs3wg/5W7xcHxHs2ZUZKe9hPBPRU6gcUkV7USkHrlVBMANSpOBcenF8xOKdh6
         awAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rdsT8wChIEQo34ZPuzpJxdwcakwW6MiV0N2Abgg/21M=;
        b=AbzTlkYGDEA8jaGRn6Iyu4tE09Sm1GBJa/9qJuXHEoA7SDSjDwZS/Ey6yCaIPwrQ2J
         bpUIdPR113xEjvvgeQW8JCRhRmIFbOaXNlTHvPOF0PrnN2LvxV08dEQBMHKkAGF3qQhD
         zJlB/GAnno8KsATQwzqwMLm5etC8iwlhhue2fBL1C8xjkCpekAOA5lWPEmXfjTDi2+yV
         cDVeJ2IQZ9I9mvCc2CWNP2g2g0X3uKDLqpimQdxzW9C4cg6c1gK9UcrEIQEUoinXFziK
         /93ERXhydBA5lgsCnmKc+0MSf2kEHn+yJpNiermur1XSZfvYYvbQMC0B4zOjfHONzDt4
         IKRQ==
X-Gm-Message-State: APjAAAV36CAEVNBQo50s1K3V/Sc9VQAF63UYZs0D4pjB+KxIOVTvu8iL
        0AfusUFf9PSwP/dfx4kvRIc=
X-Google-Smtp-Source: APXvYqzVSp9s23hDPVvqtmg5snCCxKVDNaecP5BhPPyak0N4qyp3BTK9nFbnTPQNjmREmPryxRAMmA==
X-Received: by 2002:a17:90a:80c1:: with SMTP id k1mr5711048pjw.30.1559047158748;
        Tue, 28 May 2019 05:39:18 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id g8sm2485851pjp.17.2019.05.28.05.39.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 05:39:18 -0700 (PDT)
Date:   Tue, 28 May 2019 20:38:58 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190528123858.GA23855@zhanggen-UX430UQ>
References: <20190524030117.GA6024@zhanggen-UX430UQ>
 <20190528113922.E2B1060312@smtp.codeaurora.org>
 <20190528121452.GA23464@zhanggen-UX430UQ>
 <87tvde4v3u.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvde4v3u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 03:33:09PM +0300, Kalle Valo wrote:
> Yeah, I don't see how that thread proves that these patches are correct.
> 
Sure, I didn't mean that we came to an agreement that these patches are
correct.
> > Further, I e-mailed Greg K-H about when should we use devm_kmalloc().
> >
> > On Tue, May 28, 2019 at 08:32:57AM +0800, Gen Zhang wrote:
> >> devm_kmalloc() is used to allocate memory for a driver dev. Comments
> >> above the definition and doc 
> >> (https://www.kernel.org/doc/Documentation/driver-model/devres.txt) all
> >> imply that allocated the memory is automatically freed on driver attach,
> >> no matter allocation fail or not. However, I examined the code, and
> >> there are many sites that devm_kfree() is used to free devm_kmalloc().
> >> e.g. hisi_sas_debugfs_init() in drivers/scsi/hisi_sas/hisi_sas_main.c.
> >> So I am totally confused about this issue. Can anybody give me some
> >> guidance? When should we use devm_kfree()?
> > He replied: If you "know" you need to free the memory now, 
> > call devm_kfree(). If you want to wait for it to be cleaned up latter, 
> > like normal, then do not call it.
> >
> > So could please look in to this issue?
> 
> Sorry, no time to investigate this in detail. If you think the patches
> are correct you can resend them and get someone familiar with the driver
> to provide Reviewed-by, then I will apply them.
> 
> -- 
> Kalle Valo
Ok, thanks for your time. I will follow your suggestions.

Thanks
Gen
