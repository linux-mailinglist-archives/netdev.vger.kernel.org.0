Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB672A3AF8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfH3PuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:50:01 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38433 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3PuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:50:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id w11so3568300plp.5;
        Fri, 30 Aug 2019 08:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=co3bGrM/Y5VLsvT0nTMJHcvtw5mE9WMAkKrlhFtcrF8=;
        b=C16sucQoN3owh8h2r0ees16i+d24t64nMqv4X0wt/MS+KLq39nQIdl9yn3xnWDlmG7
         qZLbDJb4pijhXz3T6to5lPSKS/y5mYwQblb/eCsWydKolc6RTfvf0cPz1/YbCXq9hR+t
         J83tIQkYy5gQe7ogYEpeVyRQ8xEYNX9nOy+RDiogZqKv2sPSv43nlRRUotZFdEwewdYt
         VmfdlASW+XeU0YMSzc2cH1fOOOA77cLJFDtKzZvwjBxHoBUo+BgDoXqZhAeNn2IGReqQ
         ojEYLEyQO00m9XsnISX0N0SP1pSsRNBGrD0Rlsf96Bzt31XjG7Q47pjyfY1LKtJg+DKV
         NMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=co3bGrM/Y5VLsvT0nTMJHcvtw5mE9WMAkKrlhFtcrF8=;
        b=j/XYEsLN0Odbqedp759k5OZdKVL53ibXESIJGbJw0CeOXwgYpc16BYSCn6ZmgfgrNQ
         0l1TtcGym8caQjtNPJKUtx6nL+YJsM8aSKOxB0gduqXHbudXr5UDtD4rWk7yFNXhX+BW
         gE+e1nfhxNhnl4Su7ckOJcH/VYv3gx32JUCy59L4WvG0VvuyasDwqiMAvbDjrWlEE3j5
         L+0EDb6Gl6Y8cCxuJ6rdF+Zs9ig+OUItufhRuD/Ve8m/7qLAbJuZT8HkBI59A/MVjBba
         ZxYDXW8+rclnnWihd8EdOLglQABeXE9kBEFiQlRTm70wQfFvmXTB8gPlhyMx8gTmjPFT
         wDgg==
X-Gm-Message-State: APjAAAUizg8BoFoMroV8SLNjou0Vrg7yz/ZaDtX1g2iRz3O7XJ3pqWtP
        yx3KteHR9ory26aqxw8ZuHQ=
X-Google-Smtp-Source: APXvYqymaCmMsBIeetw43WWKwvF2vJg4649iUp2ePqLxRr+QNQbkOtCjHRGkdwx9PJVSxmhO4pQlOQ==
X-Received: by 2002:a17:902:720a:: with SMTP id ba10mr15474351plb.231.1567180199678;
        Fri, 30 Aug 2019 08:49:59 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id h70sm6421499pgc.36.2019.08.30.08.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:49:59 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 10/12] samples/bpf: add buffer recycling for
 unaligned chunks to xdpsock
Date:   Fri, 30 Aug 2019 08:49:57 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <CDECD1EE-EFE2-421A-94B9-3BAF1128D5EC@gmail.com>
In-Reply-To: <20190827022531.15060-11-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-11-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> This patch adds buffer recycling support for unaligned buffers. Since we
> don't mask the addr to 2k at umem_reg in unaligned mode, we need to make
> sure we give back the correct (original) addr to the fill queue. We achieve
> this using the new descriptor format and associated masks. The new format
> uses the upper 16-bits for the offset and the lower 48-bits for the addr.
> Since we have a field for the offset, we no longer need to modify the
> actual address. As such, all we have to do to get back the original address
> is mask for the lower 48 bits (i.e. strip the offset and we get the address
> on it's own).
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
