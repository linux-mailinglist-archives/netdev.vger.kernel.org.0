Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCDA105CC7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKUWoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:44:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKUWob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:44:31 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 520E0150A92ED;
        Thu, 21 Nov 2019 14:44:30 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:44:29 -0800 (PST)
Message-Id: <20191121.144429.649625073638417068.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jiri@mellanox.com, dsahern@gmail.com, idosch@mellanox.com,
        petrm@mellanox.com, jakub.kicinski@netronome.com,
        nikolay@cumulusnetworks.com, parav@mellanox.com,
        roopa@cumulusnetworks.com, johannes.berg@intel.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: rtnetlink: prevent underflows in
 do_setvfinfo()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
References: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 14:44:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 20 Nov 2019 15:34:38 +0300

> The "ivm->vf" variable is a u32, but the problem is that a number of
> drivers cast it to an int and then forget to check for negatives.  An
> example of this is in the cxgb4 driver.
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
>   2890  static int cxgb4_mgmt_get_vf_config(struct net_device *dev,
>   2891                                      int vf, struct ifla_vf_info *ivi)
>                                             ^^^^^^
>   2892  {
>   2893          struct port_info *pi = netdev_priv(dev);
>   2894          struct adapter *adap = pi->adapter;
>   2895          struct vf_info *vfinfo;
>   2896  
>   2897          if (vf >= adap->num_vfs)
>                     ^^^^^^^^^^^^^^^^^^^
>   2898                  return -EINVAL;
>   2899          vfinfo = &adap->vfinfo[vf];
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> There are 48 functions affected.
 ...
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

I'm going to apply this and queue it up for -stable.

The u32 conversion should happen in next.
