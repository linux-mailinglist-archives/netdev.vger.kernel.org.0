Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A396CA8A2
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjC0PJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjC0PJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94A32D71;
        Mon, 27 Mar 2023 08:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5914B81617;
        Mon, 27 Mar 2023 15:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54113C433D2;
        Mon, 27 Mar 2023 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679929749;
        bh=MCExPz9vDop0E9u20UEk1fhx2X1UnQ3FTZ4kvpzLi4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3Wr+YsBC4b5ofeiyF7AZ8XOKtnhgVwMd56Akpe2478YCnSOxNfZykMSxd1ezJWt9
         eLvBt7+AQjCg4Gm8iPomjAqEIkyB/ICjxiyDGH5j6bPp0QXaZN0Ar22tve2OMYDa9y
         auDvF7+xYZH9xy3zPnij6oPD6GqTEwDVXcNGLFu54mBUzXspLxLUllTUj8HOs6/5xU
         DA/dk9NYSRHAFDDkRbn+Zc0uUblb474Dvi0ounSpmsVyrFUUCEeY4HTtL/iKR6bJOe
         qQmwmnjPCgH7ruYFH4tWLP+VlQLZcasKZbsVbKbYu/4TFA9PoVIO+q6Ej5wQ8Q4kx8
         r2KiPMfwyurmQ==
Date:   Mon, 27 Mar 2023 08:09:07 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/14] net/mlx5: Rename kfree_rcu() to
 kfree_rcu_mightsleep()
Message-ID: <ZCGxk5k2yRGg3o33@x130>
References: <20230315181902.4177819-1-joel@joelfernandes.org>
 <20230315181902.4177819-6-joel@joelfernandes.org>
 <CAEXW_YQLQqB9CAzEyddzOJkKx3y268T7g-E313mDsjXVQRT0Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXW_YQLQqB9CAzEyddzOJkKx3y268T7g-E313mDsjXVQRT0Dw@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Mar 08:34, Joel Fernandes wrote:
>On Wed, Mar 15, 2023 at 2:19 PM Joel Fernandes (Google)
><joel@joelfernandes.org> wrote:
>>
>> From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
>>
>> The kfree_rcu() and kvfree_rcu() macros' single-argument forms are
>> deprecated.  Therefore switch to the new kfree_rcu_mightsleep() and
>> kvfree_rcu_mightsleep() variants. The goal is to avoid accidental use
>> of the single-argument forms, which can introduce functionality bugs in
>> atomic contexts and latency bugs in non-atomic contexts.
>
>In a world where patches anxiously await their precious Ack, could
>today be our lucky day on this one?
>
>We need Acks to take this in for 6.4. David? Others?
>

For mlx5 usually me, but since this is a larger series that is not mlx5
centric and targeting multiple tree, I really don't know which subsystem
you should be targeting.. for netdev submissions you need to specify the
targeted branch e.g. [PATCH v2 net-next 06/14] ... 


FWIW:

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


> - Joel
>
>
>>
>> Cc: Ariel Levkovich <lariel@nvidia.com>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>> Cc: Vlad Buslov <vladbu@nvidia.com>
>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c  | 2 +-
>>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
>> index ca834bbcb44f..8afcec0c5d3c 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
>> @@ -242,7 +242,7 @@ mlx5e_int_port_remove(struct mlx5e_tc_int_port_priv *priv,
>>                 mlx5_del_flow_rules(int_port->rx_rule);
>>         mapping_remove(ctx, int_port->mapping);
>>         mlx5e_int_port_metadata_free(priv, int_port->match_metadata);
>> -       kfree_rcu(int_port);
>> +       kfree_rcu_mightsleep(int_port);
>>         priv->num_ports--;
>>  }
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> index 08d0929e8260..b811dad7370a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> @@ -670,7 +670,7 @@ static int mlx5e_macsec_del_txsa(struct macsec_context *ctx)
>>
>>         mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
>>         mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
>> -       kfree_rcu(tx_sa);
>> +       kfree_rcu_mightsleep(tx_sa);
>>         macsec_device->tx_sa[assoc_num] = NULL;
>>
>>  out:
>> @@ -849,7 +849,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
>>         xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
>>         metadata_dst_free(rx_sc->md_dst);
>>         kfree(rx_sc->sc_xarray_element);
>> -       kfree_rcu(rx_sc);
>> +       kfree_rcu_mightsleep(rx_sc);
>>  }
>>
>>  static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
>> --
>> 2.40.0.rc1.284.g88254d51c5-goog
>>
