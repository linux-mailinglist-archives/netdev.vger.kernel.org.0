Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD412FA9F
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgACQgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:36:09 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34163 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgACQgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:36:08 -0500
Received: by mail-qk1-f196.google.com with SMTP id j9so34586631qkk.1
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 08:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sudCo7UPl2UlykD1ORZaeISXEUoxyJkiMctvtW517Vk=;
        b=Eruve59U1yI6zP+DxqzqA6nOcfTxBDD2pvh1trBTe+FIfzgwQKQt9nZ8gEpOeV9C6G
         ySUQVUr5F8gO7fcUqlyy/1o6PYcXuY3aO/le+gaPWnBy66Z4b09Vn7D6UdkPPGK0X1RO
         6vqFyrIhzRPZwieZHcCenPPyNRl2nDxm+8kXc+E/euj9D+Q6miZAXaDedlXU+FKeI26s
         FeuTtRlYbmQ5LUs/L6btIPvJXQTNy0XrRcjvo9vIp8b4uuFuUtX2FnRKGP8+B0tvRfYS
         31+QXO7LmHL7CGOXDFpFuemQa6G90fpxFrmFnAn+3T+dxIABrpCXux5MrFKGirJTkppv
         Pk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sudCo7UPl2UlykD1ORZaeISXEUoxyJkiMctvtW517Vk=;
        b=Gva01e0wK6JZRVTJZovb3JhTk2JkGyEr2+p3Fu2Fa6S0k6rLQTDY85pCoUDBjWvrTb
         dI3uldQ3dHUcVm/zo0qmfNoBn7xmdF83oncGbe3a5fQAKe6T5WZ98o/hSLy2I+vXWdEd
         aYDbvs+rjsyAQjTlt522rZvKPgIfCYP7DUJxI4qUI2qrTvuUTPBuGysOSl6ubmTItxYH
         IdPUNgqwurSnHRle/fWGVRHx2tfhnO/BDhlbAGu43MwQQ6rMV4tFE6hiFZqm8K5pFL8C
         a8T/GLaF6fkDozczMzc9zsEfq6N6QLASOSz6Oo5G2pZmSA8n7kIrc8Tx7FNzX3aPWohZ
         wg7g==
X-Gm-Message-State: APjAAAUxOs4V5KCeaUr3fARLJKc0FJghQeR8hgAOSlItnUKhRg+1fH7+
        O2wqcEhk4hiuvz11w3Ebcc4gjQ==
X-Google-Smtp-Source: APXvYqzXPuO8Q2iCwT4AOJu6PVHWbP/PHxoj1vucsu2b26srgGmPlSmUUaaGVFAEw5nH5VrXrOROLg==
X-Received: by 2002:a37:a807:: with SMTP id r7mr63400124qke.346.1578069367426;
        Fri, 03 Jan 2020 08:36:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id a36sm18738401qtk.29.2020.01.03.08.36.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 08:36:06 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1inPvi-0001M8-Gt; Fri, 03 Jan 2020 12:36:06 -0400
Date:   Fri, 3 Jan 2020 12:36:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
Message-ID: <20200103163606.GC9706@ziepe.ca>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
 <20200103133749.GA9706@ziepe.ca>
 <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 06:31:18PM +0200, Liran Alon wrote:

> > I am surprised that AMD is different here, the evolution of the WC
> > feature on x86 was to transparently speed up graphics, so I'm pretty
> > surprised AMD can get away with not ordering the same as Intel..
> 
> Completely agree. I was very surprised to see this from AMD SDM and
> Optimization Guide SDM.  It made sense to me too that graphics frame
> buffer is written to WC memory and then is committed to GPU by
> writing to some doorbell register mapped as UC memory.

It is possible this manual is wrong or misleading?

Having WC writes not strongly order after UC writes to the same
device, on x86, seems very, very surprising to me. Everything is
ordered on x86 :)

Jason
