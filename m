Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B5534C4B
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbiEZJI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346823AbiEZJI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:08:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EBD1FCC0;
        Thu, 26 May 2022 02:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653556135; x=1685092135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BbgZo0fAvzwrr8/AxG79gLLntIyYXKjXVTnVr9TmLbk=;
  b=SVgZeJbXKOBo9mrpxgOMMYUr8dmEe/CAmRHumIk54DTikZcKKGFhuOfF
   lanoOGZQ2ayux9AcnfflaGZwN4gHCcTebsPyG+6Yd056IUh1pBKWQ19PM
   NJaH8VGasGpppcUw82GPySPIBIZmFl+voqji8930s3aeNJMvxzU9HpWCv
   hIZtu5pedx2dLQOc4Vh6RJXvNNft8qpt1lvUrI7ndhweF3Qn8XtgxHFbq
   47Hf+8Nxg125Jcecm0y+fqIXNzsCPFvfug6+nCQKSVNAnJYNpQPYxkFRW
   UikBpGA0LlpL5zll7P4n3o4ygyfIxodIXYgVbSz0TQXq2C2741jhFrEJx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="299428592"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="299428592"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 02:08:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="718170597"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 26 May 2022 02:08:52 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nu9UB-0003jg-Gz;
        Thu, 26 May 2022 09:08:51 +0000
Date:   Thu, 26 May 2022 17:02:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianglei Nie <niejianglei2021@163.com>, pizza@shaftnet.org,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: Re: [PATCH] cw1200: Fix memory leak in cw1200_set_key()
Message-ID: <202205261656.CWDWN8nG-lkp@intel.com>
References: <20220526033003.473943-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526033003.473943-1-niejianglei2021@163.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jianglei,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main v5.18 next-20220526]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jianglei-Nie/cw1200-Fix-memory-leak-in-cw1200_set_key/20220526-114747
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220526/202205261656.CWDWN8nG-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3d546191ad9d7d2ad2c7928204b9de51deafa675)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1e40283730dea11a1556d589925313cdca295484
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jianglei-Nie/cw1200-Fix-memory-leak-in-cw1200_set_key/20220526-114747
        git checkout 1e40283730dea11a1556d589925313cdca295484
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/wireless/st/cw1200/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/wireless/st/cw1200/sta.c:826:26: error: use of undeclared identifier 'idx'
                           cw1200_free_key(priv, idx);
                                                 ^
   1 error generated.


vim +/idx +826 drivers/net/wireless/st/cw1200/sta.c

   679	
   680	int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
   681			   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
   682			   struct ieee80211_key_conf *key)
   683	{
   684		int ret = -EOPNOTSUPP;
   685		struct cw1200_common *priv = dev->priv;
   686		struct ieee80211_key_seq seq;
   687	
   688		mutex_lock(&priv->conf_mutex);
   689	
   690		if (cmd == SET_KEY) {
   691			u8 *peer_addr = NULL;
   692			int pairwise = (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ?
   693				1 : 0;
   694			int idx = cw1200_alloc_key(priv);
   695			struct wsm_add_key *wsm_key = &priv->keys[idx];
   696	
   697			if (idx < 0) {
   698				ret = -EINVAL;
   699				goto finally;
   700			}
   701	
   702			if (sta)
   703				peer_addr = sta->addr;
   704	
   705			key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE |
   706				      IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
   707	
   708			switch (key->cipher) {
   709			case WLAN_CIPHER_SUITE_WEP40:
   710			case WLAN_CIPHER_SUITE_WEP104:
   711				if (key->keylen > 16) {
   712					cw1200_free_key(priv, idx);
   713					ret = -EINVAL;
   714					goto finally;
   715				}
   716	
   717				if (pairwise) {
   718					wsm_key->type = WSM_KEY_TYPE_WEP_PAIRWISE;
   719					memcpy(wsm_key->wep_pairwise.peer,
   720					       peer_addr, ETH_ALEN);
   721					memcpy(wsm_key->wep_pairwise.keydata,
   722					       &key->key[0], key->keylen);
   723					wsm_key->wep_pairwise.keylen = key->keylen;
   724				} else {
   725					wsm_key->type = WSM_KEY_TYPE_WEP_DEFAULT;
   726					memcpy(wsm_key->wep_group.keydata,
   727					       &key->key[0], key->keylen);
   728					wsm_key->wep_group.keylen = key->keylen;
   729					wsm_key->wep_group.keyid = key->keyidx;
   730				}
   731				break;
   732			case WLAN_CIPHER_SUITE_TKIP:
   733				ieee80211_get_key_rx_seq(key, 0, &seq);
   734				if (pairwise) {
   735					wsm_key->type = WSM_KEY_TYPE_TKIP_PAIRWISE;
   736					memcpy(wsm_key->tkip_pairwise.peer,
   737					       peer_addr, ETH_ALEN);
   738					memcpy(wsm_key->tkip_pairwise.keydata,
   739					       &key->key[0], 16);
   740					memcpy(wsm_key->tkip_pairwise.tx_mic_key,
   741					       &key->key[16], 8);
   742					memcpy(wsm_key->tkip_pairwise.rx_mic_key,
   743					       &key->key[24], 8);
   744				} else {
   745					size_t mic_offset =
   746						(priv->mode == NL80211_IFTYPE_AP) ?
   747						16 : 24;
   748					wsm_key->type = WSM_KEY_TYPE_TKIP_GROUP;
   749					memcpy(wsm_key->tkip_group.keydata,
   750					       &key->key[0], 16);
   751					memcpy(wsm_key->tkip_group.rx_mic_key,
   752					       &key->key[mic_offset], 8);
   753	
   754					wsm_key->tkip_group.rx_seqnum[0] = seq.tkip.iv16 & 0xff;
   755					wsm_key->tkip_group.rx_seqnum[1] = (seq.tkip.iv16 >> 8) & 0xff;
   756					wsm_key->tkip_group.rx_seqnum[2] = seq.tkip.iv32 & 0xff;
   757					wsm_key->tkip_group.rx_seqnum[3] = (seq.tkip.iv32 >> 8) & 0xff;
   758					wsm_key->tkip_group.rx_seqnum[4] = (seq.tkip.iv32 >> 16) & 0xff;
   759					wsm_key->tkip_group.rx_seqnum[5] = (seq.tkip.iv32 >> 24) & 0xff;
   760					wsm_key->tkip_group.rx_seqnum[6] = 0;
   761					wsm_key->tkip_group.rx_seqnum[7] = 0;
   762	
   763					wsm_key->tkip_group.keyid = key->keyidx;
   764				}
   765				break;
   766			case WLAN_CIPHER_SUITE_CCMP:
   767				ieee80211_get_key_rx_seq(key, 0, &seq);
   768				if (pairwise) {
   769					wsm_key->type = WSM_KEY_TYPE_AES_PAIRWISE;
   770					memcpy(wsm_key->aes_pairwise.peer,
   771					       peer_addr, ETH_ALEN);
   772					memcpy(wsm_key->aes_pairwise.keydata,
   773					       &key->key[0], 16);
   774				} else {
   775					wsm_key->type = WSM_KEY_TYPE_AES_GROUP;
   776					memcpy(wsm_key->aes_group.keydata,
   777					       &key->key[0], 16);
   778	
   779					wsm_key->aes_group.rx_seqnum[0] = seq.ccmp.pn[5];
   780					wsm_key->aes_group.rx_seqnum[1] = seq.ccmp.pn[4];
   781					wsm_key->aes_group.rx_seqnum[2] = seq.ccmp.pn[3];
   782					wsm_key->aes_group.rx_seqnum[3] = seq.ccmp.pn[2];
   783					wsm_key->aes_group.rx_seqnum[4] = seq.ccmp.pn[1];
   784					wsm_key->aes_group.rx_seqnum[5] = seq.ccmp.pn[0];
   785					wsm_key->aes_group.rx_seqnum[6] = 0;
   786					wsm_key->aes_group.rx_seqnum[7] = 0;
   787					wsm_key->aes_group.keyid = key->keyidx;
   788				}
   789				break;
   790			case WLAN_CIPHER_SUITE_SMS4:
   791				if (pairwise) {
   792					wsm_key->type = WSM_KEY_TYPE_WAPI_PAIRWISE;
   793					memcpy(wsm_key->wapi_pairwise.peer,
   794					       peer_addr, ETH_ALEN);
   795					memcpy(wsm_key->wapi_pairwise.keydata,
   796					       &key->key[0], 16);
   797					memcpy(wsm_key->wapi_pairwise.mic_key,
   798					       &key->key[16], 16);
   799					wsm_key->wapi_pairwise.keyid = key->keyidx;
   800				} else {
   801					wsm_key->type = WSM_KEY_TYPE_WAPI_GROUP;
   802					memcpy(wsm_key->wapi_group.keydata,
   803					       &key->key[0],  16);
   804					memcpy(wsm_key->wapi_group.mic_key,
   805					       &key->key[16], 16);
   806					wsm_key->wapi_group.keyid = key->keyidx;
   807				}
   808				break;
   809			default:
   810				pr_warn("Unhandled key type %d\n", key->cipher);
   811				cw1200_free_key(priv, idx);
   812				ret = -EOPNOTSUPP;
   813				goto finally;
   814			}
   815			ret = wsm_add_key(priv, wsm_key);
   816			if (!ret)
   817				key->hw_key_idx = idx;
   818			else
   819				cw1200_free_key(priv, idx);
   820		} else if (cmd == DISABLE_KEY) {
   821			struct wsm_remove_key wsm_key = {
   822				.index = key->hw_key_idx,
   823			};
   824	
   825			if (wsm_key.index > WSM_KEY_MAX_INDEX) {
 > 826				cw1200_free_key(priv, idx);
   827				ret = -EINVAL;
   828				goto finally;
   829			}
   830	
   831			cw1200_free_key(priv, wsm_key.index);
   832			ret = wsm_remove_key(priv, &wsm_key);
   833		} else {
   834			pr_warn("Unhandled key command %d\n", cmd);
   835		}
   836	
   837	finally:
   838		mutex_unlock(&priv->conf_mutex);
   839		return ret;
   840	}
   841	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
