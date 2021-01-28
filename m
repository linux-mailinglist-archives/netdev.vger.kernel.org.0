Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7198C307196
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhA1IfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:35:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231698AbhA1IeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 03:34:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8894364DD6;
        Thu, 28 Jan 2021 08:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611822802;
        bh=gz/hFTIJqvPr/vwU5QDCVyPbW0WDgb51z650rdRhlfM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K2mhmAsIN5VmeWptxyCL+gcCHwhOTdMJvRKBjUFVzJbDWXxs2SQT7WZJdqUMjE+Df
         v8ChQHpfFNKINV2NS/kKl0ZM+mXr37S996mLlqXIi3RhyIcMj102+ew+MdefhHYc5f
         pugJsF85kSyI53ZOpuwm4Jnkz4lKrfOo5ZnrwImI1AIzLGlNwKlGlSOUt/3YWnzdCU
         7U5R1bEdZBomLpGotO/F/CHj3yhvCkRFmKFRq0HS5XayPj4wqSaBKtuXDM+LhIGQGM
         5q7ElRWynWO6sNeSDmBixePY17owkzaMdieiNgae0aaTZWWO4TpxLNEpAGmF1sqyJl
         0oFHeJe4ZUI+Q==
Message-ID: <1fd6aa2c643b50b534476da142555a229ed1b534.camel@kernel.org>
Subject: Re: [net 01/12] net/mlx5: Fix memory leak on flow table creation
 error flow
From:   Saeed Mahameed <saeed@kernel.org>
To:     kuba <kuba@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        roid@nvidia.com, maord@nvidia.com
Date:   Thu, 28 Jan 2021 00:33:20 -0800
In-Reply-To: <161180461255.10551.14683896693302400823.git-patchwork-notify@kernel.org>
References: <20210126234345.202096-2-saeedm@nvidia.com>
         <161180461255.10551.14683896693302400823.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-28 at 03:30 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This series was applied to netdev/net.git (refs/heads/master):
> 
> 
...

>     https://git.kernel.org/netdev/net/c/89e394675818
>   - [net,09/12] net/mlx5e: Correctly handle changing the number of
> queues when the interface is down



Hi Jakub, 

I just noticed that this patch will conflict with HTB offlaod feature
in net-next, I couldn't foresee it before in my queues since HTB wasn't
submitted through my trees.

anyway to solve the conflict just use this hunk:

 +      /* Don't allow changing the number of channels if HTB offload
is active,
 +       * because the numeration of the QoS SQs will change, while
per-queue
 +       * qdiscs are attached.
 +       */
 +      if (priv->htb.maj_id) {
 +              err = -EINVAL;
 +              netdev_err(priv->netdev, "%s: HTB offload is active,
cannot change the number of channels\n",
 +                         __func__);
 +              goto out;
 +      }
 +
-       new_channels.params = priv->channels.params;
-       new_channels.params.num_channels = count;
+       new_channels.params = *cur_params;



Thanks,
Saeed.


