Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3631028F1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfKSQK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:10:59 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34950 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbfKSQK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:10:59 -0500
Received: by mail-io1-f68.google.com with SMTP id x21so23855815ior.2
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yxTg9Jz6CUPbj7hb+zClDPA6shnTNr7Uh8vLjm12KTA=;
        b=oGIJW8HfkgkobB0o2Qa1NbNfnl9mEqSGpPEO2LkogyZvOuMJQ7TF55da86qlugqMCd
         338Wge2YPFXsoEIf9RGDawq7jpCCeV3jwC0W058T6wHLBemhZJS3koszJqUTfQULDiaX
         2B6RyRY6HS9AE+8hVENsQBKSpUdhkmyAKNXz0Nm/Cxj0QFJRN/CWS+DE/OAhOnYHg0xk
         tK1FlPGkzCpUU1kARsuIumFoSGAGKhbP5ourqDXhrP7e5xrJzr7bWyrrGYocI1tJI7bI
         UgAaDI7OLq1bomHv0lR8zAsfor6M3fEsHwxDtlUp7bVspKwb2e69Lw3GuCnkI9VLqTxF
         /QFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yxTg9Jz6CUPbj7hb+zClDPA6shnTNr7Uh8vLjm12KTA=;
        b=PvAu4cEQesI6gB85MMWb6IX8l34CZqPQtEcYdban+/IMd8tMYRS2AmWmjvbULOxoRc
         lae5V8DhejgRuGVY+h5zlHv6NZyuIbtFQ/RmnQzW4BDaHLYDj3ntkg9FKKYaAHlvVuZS
         Pd7Ub7lFVe9JgPb20YkJgaqTqKj6W/XECFHeMKPM9+B/T9155m5G1LyhRTjLCZqlbwaz
         SmW8rAs61SDkjTOCc9rv5HvWJrP6SVmrbEdmcviaSgvv5vuUjpefyc6ndFYXaHVszkLo
         5uXe447X6wn/PbNuW5bMm/ZTTPpOdxj47XhGmBeu77hEMvtvanXA0YI2+1TqasB8U3/P
         fDcA==
X-Gm-Message-State: APjAAAULmlcpLCtjIAcucIJh5CHtul1KaP/St77hF8p+wpFbbucI8p2o
        whnjFhN68aVQOrQ/ANcPh4G2XMRhFSTu5Q==
X-Google-Smtp-Source: APXvYqw/6l4rejQYc8a+bdmv6/89DOI3Ir5+fK0WCl1y9yQpIdn8Kiz4M9g4FLh+4h0UiHB53RA+ow==
X-Received: by 2002:a02:140a:: with SMTP id 10mr18915165jag.72.1574179857938;
        Tue, 19 Nov 2019 08:10:57 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u6sm5616560ilm.22.2019.11.19.08.10.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:10:56 -0800 (PST)
Subject: Re: [PATCH v6 15/24] fs/io_uring: set FOLL_PIN via pin_user_pages()
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-16-jhubbard@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ae65d1b-a3eb-74ed-afce-c493de5bbfd3@kernel.dk>
Date:   Tue, 19 Nov 2019 09:10:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119081643.1866232-16-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 1:16 AM, John Hubbard wrote:
> Convert fs/io_uring to use the new pin_user_pages() call, which sets
> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
> tracking of pinned pages, and therefore for any code that calls
> put_user_page().
> 
> In partial anticipation of this work, the io_uring code was already
> calling put_user_page() instead of put_page(). Therefore, in order to
> convert from the get_user_pages()/put_page() model, to the
> pin_user_pages()/put_user_page() model, the only change required
> here is to change get_user_pages() to pin_user_pages().
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

You dropped my reviewed-by now... Given the file, you'd probably want
to keep that.

-- 
Jens Axboe

