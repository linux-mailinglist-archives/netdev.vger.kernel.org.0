Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6052612FCD7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgACTGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 14:06:42 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32862 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbgACTGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 14:06:41 -0500
Received: by mail-qk1-f196.google.com with SMTP id d71so26713507qkc.0
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 11:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EUhwY4KN3Hi+wm+tnv9ZA4z55nw+ALefY3jU2duuCU0=;
        b=dU+uoPDjAMvMqUkH3zdKc5lBHfmgslkIvSvgbRSsETucM72+/5AR706J1qxKdWYxMy
         zrQNoVmazalzmV6BVpgUd0Hdd0FJKlhPMQRV1Kn5zzdLJA+zfxNIKJFj5aBIRGx85ADi
         AGk+m7Q2s+HIiRNIg6CwF6G8mczWXk+ciquiR2TvkQsub9GM4QVYrLyjoAHooiBBqw6J
         i5SJkZCc8zhOceaRl9wRJtZl5U9tWLgvPuC6bpurHlDxnE4kVm6SUSpXIJF1dNBM4DBM
         aou6rih0etSIbAHpsfh1KzBX9IBErIoseIPHl4Lp2inCJHAbakwE39JqKnQ7efFTe6t1
         5UkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EUhwY4KN3Hi+wm+tnv9ZA4z55nw+ALefY3jU2duuCU0=;
        b=MjYdQtMwHDAtI2CayNe3ULazES9kDdoep1ZbFBPdRKy1joFittcxvRRm/2bwSwzN+O
         tHvKjuooMiMOnJVeRsQ/W87qyVDGpHeql91GAdh5aCCj5q/SI5tV4KxH0VyHE7887RLR
         KVdzWwnI9SkcL5oK+GL6p3coP6W3j4Wb3L9BEHoF99u5tRxivBf/Di7kSkDhipfH50JX
         RBPYQYWlEMr2dykY6rwc8ngd6WlEYuwoEDsSBbfzqqBiX7hHuw/kXLCKlaYvdDHWTHoZ
         /wlr+7ipULsTx8n8sIxEKBc/oeAPN7GO5R05fA7moJ8Gmza8kR0JCdJjDrjmAM3rGMVr
         SClA==
X-Gm-Message-State: APjAAAVTmzFhfcydjJLeosiwp66wUNCHgGcKODOi7ZZkAm8p2QCD7CNA
        crExNVMgItEtMwD18b4OZPlKNA==
X-Google-Smtp-Source: APXvYqz1n8Sh0mx4cCcsQyHa2xl1wQP/5+oQQG13fHDdhdNT2yV1hAnWgJ3cAg2DVYLvj9U3j0xyDQ==
X-Received: by 2002:a37:77c5:: with SMTP id s188mr74200680qkc.369.1578078400638;
        Fri, 03 Jan 2020 11:06:40 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u4sm16688451qkh.59.2020.01.03.11.06.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 11:06:40 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1inSHP-0005Qf-J8; Fri, 03 Jan 2020 15:06:39 -0400
Date:   Fri, 3 Jan 2020 15:06:39 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
Message-ID: <20200103190639.GD9706@ziepe.ca>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
 <20200103133749.GA9706@ziepe.ca>
 <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
 <1C8D5596-F9AD-4E9F-B462-D63DCEEFFE54@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1C8D5596-F9AD-4E9F-B462-D63DCEEFFE54@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 08:38:51PM +0200, Liran Alon wrote:

> Actually after re-reading AMD Optimization Guide SDM, I see it is
> guaranteed that: “Write-combining is closed if all 64 bytes of the
> write buffer are valid”.  And this is indeed always the case for AWS
> ENA LLQ. Because as can be seen at ena_com_config_llq_info(),
> desc_list_entry_size is either 128, 192 or 256. i.e. Always a
> multiple of 64 bytes. So this explains why this wasn’t an issue in
> production.

That makes a lot of sense

So, the problem with defining WC in the kernel memory model still
remains, but it is back to a theoretical one.

Jason
