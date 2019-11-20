Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA211040FE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfKTQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:41:05 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41627 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728632AbfKTQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 11:41:05 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so14484871pfq.8;
        Wed, 20 Nov 2019 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WNg69dI6lMPTZ5pehKVsjQeKR7hVlS+w6JYy8Hbf0mU=;
        b=HrM8tdU5FNrjIQsOwuwPfFU/2fzWigHO2d3TqHW0SxUKIviQQ7e77FxbOlGDifHCRR
         uyjdCcPSFYeG+V4wBNFI+0PLbBL4s8lwDsQN+9eapsIZ0oGOBcp7JDmaKBbdGW3Isq00
         HK05nJ4uomvKkuNt/PVBoPUSC/zv+Fu4DpHVUHOsCtSRvvGEWlTyiOla/CW5Peb/SteM
         5wfY10x7cTSj89OdZs4y0qG8YK8tAqQDaAKwx6lQjpb9BYLq+I9CaTrj2aY0FbdbdBPD
         +reoZLEXT4Uo98eI/1ZDf5xNM6cXpGv1c1o1yu+xvOYLlVyYHnscqp8f8h2kOddpXpgU
         k+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WNg69dI6lMPTZ5pehKVsjQeKR7hVlS+w6JYy8Hbf0mU=;
        b=Wc9qVR954fWTiNW/svr3MrnSTPKYQnSHsTDSCYx7nBXwrHzByZbT9K5zpW1pz4f46e
         Ak+gtXERX6LVtb82jwP9f+OPMhlRtTUstS9oYNpU1OuLN1OlbxLZ0li8Gh4uhoXoj5Xn
         jzMfGM992vH9OmbOVmdhw4blIte6QqAelxlijmeWHmeLBo/utZybHuKgCWWKvBgH54Vy
         UEmTNklMAoTRXG3yKSG9PqKOkwl7gjzPtzSQ29339CaLkB9v6il/xLKjPiN7AEeGG8rk
         Eh07Eb1geqWR0kqBahQgiQin+Az+QMqNHfVXg1NoRpLErKg9qM0aa4lBlcYQ/p6Xryrf
         51hw==
X-Gm-Message-State: APjAAAUfcYh1wiCr3b2Ci4IJ11fJIjMLPquQ5PyzCSDrMPjccQkZ3oBo
        jnLvCWliq/ePAvws2MRxfcDjr+vJ
X-Google-Smtp-Source: APXvYqyULMxeTP6qjjM5EJ+roB8mJcF17Y8Myrb6oSIKbO+tyKNkU7aHQs9aGpLtTu+vVXWJaoWNbQ==
X-Received: by 2002:a63:524e:: with SMTP id s14mr4409429pgl.412.1574268064492;
        Wed, 20 Nov 2019 08:41:04 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d52e:b788:c6dc:7675])
        by smtp.googlemail.com with ESMTPSA id e11sm29815362pff.104.2019.11.20.08.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 08:41:03 -0800 (PST)
Subject: Re: [PATCH net] net: rtnetlink: prevent underflows in do_setvfinfo()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Parav Pandit <parav@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <24d0482c-f23f-83b1-e79e-fb84694d0a54@gmail.com>
Date:   Wed, 20 Nov 2019 09:41:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:34 AM, Dan Carpenter wrote:
> I reported this bug to the linux-rdma mailing list in April and this
> patch wasn't considered very elegant.  I can see how that's true.  The
> developer offered to write a fix which would update all the drivers to
> use u32 throughout.  I reminded him in September that this bug still
> needs to be fixed.

Since the uapi (ifla_vf_mac, ifla_vf_vlan, ...) all have u32, I agree
with that comment -- it seems like the ndo functions should be changed
from 'int vf' to 'u32 vf'.
