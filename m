Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179ADFD45B
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKOF3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:29:41 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33680 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKOF3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:29:40 -0500
Received: by mail-pf1-f194.google.com with SMTP id c184so5875711pfb.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 21:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=atnC2AMFzcg/i0Mp01bQtIoCfLx+HHbTWM8nHw4lKY3bvK8sTjwuuQEAzd/5lBqjg8
         S2gVzJA/HwmQYtqs72pyRN1J6FXkXvof9go4CmLgmO38QZr4HfrNVAzeJS6EmIVf0Xon
         frtfStys716GXGZIcxrtKpwu1jAmCujAqb+64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwWwUvjngD0vGITVGJw2bNFQc6m1rEqC7TEDYhp2gbo=;
        b=ujETOF1OkYJb47/bFwLhKVOvURNyOHCCC2fVRonCAlhKML5jsziNlt4BoIj7UJYZmS
         9+P8vshhAmtj5Cz/rJR0gdkFkJStM2uZhs2Gij20bKEDJnaemAbGALBLQ6Nl7RntwODE
         Wh5ta73Zo8l/A/z8jIZUmgfEpGjXbV8c6neSOYIEfgPC5YJmEepGisV1WjsBmpMr4zPx
         zYCPNIF4+Axs6SbUGquE4RCFg/26EUI0tG59C+X+wIQEbSzvObE7YXbTnk9n+SysaSg1
         R5lhYSrVdvWEvziRiu0hiqD3bseDsCpPBDzGOtmH+U5MxUfVx00uqWzp+/L6U6tphgwD
         iBOw==
X-Gm-Message-State: APjAAAUDE8OTgZ+1bAORHYMRstRh4Tj5ExdM/mwQo9ptitMPbFUy4yd0
        jYRWzrlmfZvffmMY4pTx3+uZ3w==
X-Google-Smtp-Source: APXvYqwt4zb0Je/V6IpxbO3fLLPDi96nB5JTyVu+Y5Gk5ifcWF6G9mnVci2ds1rUWNSyZ5xoFyc++Q==
X-Received: by 2002:a62:7c52:: with SMTP id x79mr15159448pfc.18.1573795780005;
        Thu, 14 Nov 2019 21:29:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 12sm9010639pjm.11.2019.11.14.21.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 21:29:38 -0800 (PST)
Date:   Thu, 14 Nov 2019 13:27:48 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <201911141327.4DE6510@keescook>
References: <1515636190-24061-1-git-send-email-keescook@chromium.org>
 <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911121313.1097D6EE@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 01:21:54PM -0800, Kees Cook wrote:
> How is iucv the only network protocol that has run into this? Do others
> use a bounce buffer?

Another solution would be to use a dedicated kmem cache (instead of the
shared kmalloc dma one)?

-- 
Kees Cook
